/* $Id: Profile.nsh 3515 2013-02-22 21:34:29Z IMPOMEZIA $
 * IMPOMEZIA Simple Chat
 * Copyright Р’В© 2008-2013 IMPOMEZIA <schat@impomezia.com>
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

${Name} Profile
${State} 1

${Body}
${Section}
  SetOutPath "$INSTDIR\plugins"
  File "${SCHAT_SOURCE}\plugins\Profile.dll"

  SetOutPath "$INSTDIR\doc"
  File "${SCHAT_SOURCE}\doc\ChangeLog.Profile.html"

  Delete "$INSTDIR\translations\profile_en.qm"
  Delete "$INSTDIR\translations\profile_ru.qm"
${SectionEnd}
${BodyEnd}

${Uninstall}
  Delete "$INSTDIR\plugins\Profile.dll"
  Delete "$INSTDIR\doc\ChangeLog.Profile.html"
  Delete "$INSTDIR\translations\profile_en.qm"
  Delete "$INSTDIR\translations\profile_ru.qm"

  RMDir "$INSTDIR\doc"
  RMDir "$INSTDIR\plugins"
  RMDir "$INSTDIR\translations"
${UninstallEnd}