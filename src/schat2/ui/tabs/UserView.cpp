/* Simple Chat
 * Copyright (c) 2008-2014 Alexander Sedov <imp@schat.me>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <QMenu>
#include <QMouseEvent>
#include <QUrl>

#include "ChatCore.h"
#include "ChatNotify.h"
#include "ChatSettings.h"
#include "ChatUrls.h"
#include "client/ChatClient.h"
#include "client/ChatClient.h"
#include "client/ClientChannels.h"
#include "client/ClientFeeds.h"
#include "client/SimpleClient.h"
#include "debugstream.h"
#include "feeds/FeedStrings.h"
#include "hooks/ChannelMenu.h"
#include "sglobal.h"
#include "ui/ChatIcons.h"
#include "ui/TabWidget.h"
#include "UserItem.h"
#include "UserSortFilterModel.h"
#include "UserView.h"
#include "UserViewProperties.h"

UserView::UserView(ClientChannel channel, QWidget *parent)
  : QListView(parent)
  , m_sortable(true)
  , m_channel(channel)
{
  m_source = new QStandardItemModel(this);
  m_model  = new UserSortFilterModel(ChatCore::settings()->value(ChatSettings::kUserListOffline).toBool(), this);
  m_model->setSourceModel(m_source);
  m_model->setSortRole(UserItem::SortRole);

  setModel(m_model);
  setFocusPolicy(ChatCore::settings()->value(ChatSettings::kUserListKeyboard).toBool() ? Qt::WheelFocus : Qt::TabFocus);
  setEditTriggers(QListView::NoEditTriggers);
  setSpacing(1);
  setFrameShape(QFrame::NoFrame);

  setTextElideMode(Qt::ElideMiddle);
  setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
  setStyleSheet(LS("QScrollBar:vertical{background:#fff;width:8px}QScrollBar::handle:vertical{background:#ccc;border-radius:3px}QScrollBar::sub-line:vertical,QScrollBar::add-line:vertical{height:0}QScrollBar::add-page:vertical,QScrollBar::sub-page:vertical{background:none;}"));

  QPalette p = palette();
  if (p.color(QPalette::Base) == Qt::white) {
    setAlternatingRowColors(true);
    p.setColor(QPalette::AlternateBase, QColor(247, 250, 255));
    setPalette(p);
  }

  connect(this, SIGNAL(doubleClicked(QModelIndex)), SLOT(addTab(QModelIndex)));
  connect(ChatClient::channels(), SIGNAL(channel(ChannelInfo)), SLOT(channel(ChannelInfo)));
  connect(ChatNotify::i(), SIGNAL(notify(Notify)), SLOT(notify(Notify)));
  connect(ChatCore::settings(), SIGNAL(changed(QString,QVariant)), SLOT(onSettingsChanged(QString,QVariant)));
}


/*!
 * Добавление канала-пользователя в список.
 *
 * \param user Указатель на канал.
 */
bool UserView::add(ClientChannel user)
{
  Q_ASSERT(user);

  if (!user)
    return false;

  if (m_channels.contains(user->id()))
    return reload(user->id());

  UserItem *item = new UserItem(user, m_channel);

  m_source->appendRow(item);
  m_channels.insert(user->id(), item);

  if (m_sortable)
    sort();

  return true;
}


/*!
 * Обновление информации о пользователе.
 */
bool UserView::reload(const QByteArray &id)
{
  UserItem *item = m_channels.value(id);
  if (!item)
    return false;

  item->reload();
  if (m_sortable)
    sort();

  return true;
}


/*!
 * Удаление пользователя из списка.
 *
 * \return \b false если id не найден или пользователь офлайн.
 */
bool UserView::remove(const QByteArray &id)
{
  UserItem *item = m_channels.value(id);

  if (!item)
    return false;

  const int status = item->user()->status().value();
  m_source->removeRow(m_source->indexFromItem(item).row());
  m_channels.remove(id);
  m_model->invalidateFilter();

  return status != Status::Offline;
}


void UserView::clear()
{
  m_sortable = true;
  m_source->clear();
  m_channels.clear();
}


void UserView::sort()
{
  SCHAT_DEBUG_STREAM(this << "sort()");

  m_sortable = true;
  m_model->sort(0);
  m_model->invalidateFilter();
}


void UserView::channel(const ChannelInfo &info)
{
  UserItem *item = m_channels.value(info.id());
  if (!item)
    return;

  item->reload();

  if (info.option() == ChannelInfo::Renamed)
    sort();
}


void UserView::onSettingsChanged(const QString &key, const QVariant &value)
{
  if (key == ChatSettings::kUserListOffline)
    m_model->setOfflineUsers(value.toBool());
  else if (key == ChatSettings::kUserListKeyboard)
    setFocusPolicy(value.toBool() ? Qt::WheelFocus : Qt::TabFocus);
}


void UserView::updateUserList(QString const& filter)
{
  foreach (UserItem *item, m_channels)
  {
    item->SetNameFilter(filter);
    item->reload();
  }
  sort();
}


void UserView::contextMenuEvent(QContextMenuEvent *event)
{
  QMenu menu(this);

  const QModelIndex index = m_model->mapToSource(indexAt(event->pos()));
  if (index.isValid()) {
    UserItem *item = static_cast<UserItem *>(m_source->itemFromIndex(index));
    if (item) {
      ChannelMenu::bind(&menu, item->user(), IChannelMenu::UserViewScope);
      menu.addSeparator();
    }
  }

  QAction *properties = 0;

  if (!m_dialog)
    properties = menu.addAction(SCHAT_ICON(Gear), tr("Properties"));

  if (!menu.actions().size())
    return;

  QAction *result = menu.exec(event->globalPos());

  if (result && properties && result == properties) {
    m_dialog = new UserViewProperties(this);

    TabWidget::showDialog(m_dialog);
  }
}


void UserView::focusOutEvent(QFocusEvent *event)
{
  QListView::focusOutEvent(event);

  ChatNotify::start(Notify::SetSendFocus);
}


void UserView::keyPressEvent(QKeyEvent *event)
{
  if (event->key() == Qt::Key_Return || event->key() == Qt::Key_Enter) {
    const QModelIndex index = m_model->mapToSource(currentIndex());
    if (!index.isValid())
      return;

    ChatUrls::open(ChatUrls::toUrl(static_cast<UserItem *>(m_source->itemFromIndex(index))->user(), event->modifiers() == Qt::ControlModifier ? LS("insert") : LS("open")));
    ChatNotify::start(Notify::SetSendFocus);
  }
  else
    QListView::keyPressEvent(event);
}


void UserView::mouseReleaseEvent(QMouseEvent *event)
{
  QModelIndex index = m_model->mapToSource(indexAt(event->pos()));

  if (index.isValid() && event->modifiers() == Qt::ControlModifier && event->button() == Qt::LeftButton) {
    UserItem *item = static_cast<UserItem *>(m_source->itemFromIndex(index));
    ChatUrls::open(ChatUrls::toUrl(item->user(), LS("insert")));
  }
  else if (event->button() == Qt::LeftButton && !index.isValid()) {
    setCurrentIndex(QModelIndex());
  }
  else
    QListView::mouseReleaseEvent(event);
}


/*!
 * Обработка дабл-клика по пользователю в списке,
 * высылается сигнал с идентификатором пользователя.
 */
void UserView::addTab(const QModelIndex &index)
{
  ChatUrls::open(ChatUrls::toUrl(static_cast<UserItem *>(m_source->itemFromIndex(m_model->mapToSource(index)))->user(), LS("open")));
}


void UserView::notify(const Notify &notify)
{
  if (notify.type() == Notify::FeedData) {
    const FeedNotify &n = static_cast<const FeedNotify &>(notify);
    if (n.feed() == FEED_NAME_ACL && (n.channel() == m_channel->id() || n.channel() == ChatClient::id() || n.channel() == ChatClient::serverId())) {
      foreach (UserItem *item, m_channels)
        item->reload();

      sort();
    }
  }
}
