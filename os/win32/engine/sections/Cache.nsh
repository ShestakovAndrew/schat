/* $Id: Cache.nsh 2220 2012-01-27 15:05:37Z IMPOMEZIA $
 * IMPOMEZIA Simple Chat
 * Copyright Р вЂ™Р’В© 2008-2012 IMPOMEZIA <schat@impomezia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

${Name} Cache
${State} 1

${Body}
${Section}
  SetOutPath "$INSTDIR\plugins"
  File "${SCHAT_SOURCE}\plugins\Cache.dll"

  SetOutPath "$INSTDIR\doc"
  File "${SCHAT_SOURCE}\doc\ChangeLog.Cache.html"
${SectionEnd}
${BodyEnd}

${Uninstall}
  Delete "$INSTDIR\doc\ChangeLog.Cache.html"
  Delete "$INSTDIR\plugins\Cache.dll"

  RMDir "$INSTDIR\doc"
  RMDir "$INSTDIR\plugins"
${UninstallEnd}