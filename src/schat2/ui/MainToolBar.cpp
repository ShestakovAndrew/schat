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

#include <QEvent>
#include <QMenu>
#include <QLineEdit>

#include "ChatNotify.h"
#include "sglobal.h"
#include "ui/ChatIcons.h"
#include "ui/MainToolBar.h"
#include "ui/SoundButton.h"
#include "tabs/UserView.h"

MainToolBar::MainToolBar(QWidget *parent)
  : QToolBar(parent)
{
  setIconSize(QSize(16, 16));

  m_search = new QLineEdit(this);
  m_search->setPlaceholderText(tr("Enter name..."));
  m_search->setFixedWidth(250);

  m_menu     = new QMenu(this);
  m_settings = m_menu->addAction(SCHAT_ICON(Gear),  tr("Preferences..."));
  m_about    = m_menu->addAction(SCHAT_ICON(About), tr("About..."));
  m_menu->addSeparator();
  m_quit     = m_menu->addAction(SCHAT_ICON(Quit), tr("Quit"));

  m_button = new QToolButton(this);
  m_button->setToolTip(tr("Preferences"));
  m_button->setIcon(SCHAT_ICON(Settings));
  m_button->setAutoRaise(true);
  m_button->setPopupMode(QToolButton::InstantPopup);
  m_button->setMenu(m_menu);
  m_button->setStyleSheet(LS("QToolButton::menu-indicator {image:none}"));

  m_sound = new SoundButton(this);

  addWidget(m_search);
  addWidget(m_button);
  addWidget(m_sound);

  setReady(false);

  connect(m_menu, SIGNAL(triggered(QAction*)), SLOT(triggered(QAction*)));
}


void MainToolBar::setReady(bool ready)
{
  m_settings->setEnabled(ready);
}


void MainToolBar::changeEvent(QEvent *event)
{
  if (event->type() == QEvent::LanguageChange)
    retranslateUi();

  QToolBar::changeEvent(event);
}


void MainToolBar::triggered(QAction *action)
{
  if (action == m_settings)
    ChatNotify::start(Notify::OpenSettings);
  else if (action == m_about)
    ChatNotify::start(Notify::OpenAbout);
  else if (action == m_quit)
    ChatNotify::start(Notify::Quit);
}


void MainToolBar::retranslateUi()
{
  m_button->setToolTip(tr("Preferences"));
  m_settings->setText(tr("Preferences..."));
  m_about->setText(tr("About..."));
  m_quit->setText(tr("Quit"));
}
