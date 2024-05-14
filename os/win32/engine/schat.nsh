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

!ifndef SCHAT_NSH_
!define SCHAT_NSH_

Var update

!include "engine\translations.nsh"
!AddPluginDir "contrib\plugins"

/*
 * CР С•РЎвЂ¦РЎР‚Р В°Р Р…Р ВµР Р…Р С‘РЎРЏ Р С‘Р С�Р ВµР Р…Р С‘ Р С�Р С•Р Т‘РЎС“Р В»РЎРЏ.
 * Р вЂ”Р В°Р Р†Р С‘РЎРѓР С‘РЎвЂљ Р С•РЎвЂљ MUI2.nsh.
 */
!define Name "!insertmacro MUI_SET MOD_ID "


/*
 * Р СљР В°Р С”РЎР‚Р С•РЎРѓ Р Т‘Р В»РЎРЏ Р Р†Р С”Р В»РЎР‹РЎвЂЎР ВµР Р…Р С‘РЎРЏ Р С—Р С•Р Т‘Р Т‘Р ВµРЎР‚Р В¶Р С”Р С‘ Р С�Р ВµРЎвЂ¦Р В°Р Р…Р С‘Р В·Р С�Р В° РЎРѓР С•РЎвЂ¦РЎР‚Р В°Р Р…Р ВµР Р…Р С‘РЎРЏ/Р Р†Р С•РЎРѓРЎРѓРЎвЂљР В°Р Р…Р С•Р Р†Р В»Р ВµР Р…Р С‘РЎРЏ
 * РЎРѓР С•РЎРѓРЎвЂљР С•РЎРЏР Р…Р С‘РЎРЏ РЎРѓР ВµР С”РЎвЂ Р С‘Р С‘.
 * \param _STATE 1 - РЎРѓР ВµР С”РЎвЂ Р С‘РЎРЏ Р Р†РЎвЂ№Р В±РЎР‚Р В°Р Р…Р В° Р С—Р С• РЎС“Р С�Р С•Р В»РЎвЂЎР В°Р Р…Р С‘РЎР‹, 0 - Р Р…Р Вµ Р Р†РЎвЂ№Р В±РЎР‚Р В°Р Р…Р В°.
 */
!define State "!insertmacro SCHAT_MOD_STATE "
!macro SCHAT_MOD_STATE _STATE
  !ifdef SCHAT_INIT
    ${SectionState} "${MOD_ID}" ${_STATE} ${${MOD_ID}_idx}
  !endif

  !ifdef SCHAT_POST
    !insertmacro SAVE_SECTION ${${MOD_ID}_idx} "${MOD_ID}"
  !endif
!macroend


/*
 * Р СљР В°Р С”РЎР‚Р С•РЎРѓ Р С”Р С•Р Р…РЎвЂљР ВµР в„–Р Р…Р ВµРЎР‚ Р Т‘Р В»РЎРЏ Р С•Р С—РЎР‚Р ВµР Т‘Р ВµР В»Р ВµР Р…Р С‘РЎРЏ Р С•РЎРѓР Р…Р С•Р Р†Р Р…Р С•Р в„– РЎвЂЎР В°РЎРѓРЎвЂљР С‘ Р С�Р С•Р Т‘РЎС“Р В»РЎРЏ.
 * Р пїЅРЎРѓР С—Р С•Р В»РЎРЉР В·РЎС“Р ВµРЎвЂљРЎРѓРЎРЏ Р С—Р В°РЎР‚Р Р…Р С•: ${Body} Р С‘ ${BodyEnd}.
 * Р РЋР С•Р Т‘Р ВµРЎР‚Р В¶Р С‘Р С�Р С•Р Вµ Р В±РЎС“Р Т‘Р ВµРЎвЂљ РЎР‚Р В°Р В·Р Р†РЎвЂ�РЎР‚Р Р…РЎС“РЎвЂљР С• РЎвЂљР С•Р В»РЎРЉР С”Р С• Р С—РЎР‚Р С‘ Р С•Р С—РЎР‚Р ВµР Т‘Р ВµР В»Р ВµР Р…Р С‘Р С‘ SCHAT_SECTIONS.
 * Р Т‘Р С•Р С—Р С•Р В»Р Р…Р С‘РЎвЂљР ВµР В»РЎРЉР Р…Р С• РЎС“РЎРѓРЎвЂљР В°Р Р…Р В°Р Р†Р В»Р С‘Р Р†Р В°Р ВµРЎвЂљ Р С•Р С—Р С‘РЎРѓР В°Р Р…Р С‘Р Вµ Р Т‘Р В»РЎРЏ РЎРѓР ВµР С”РЎвЂ Р С‘Р С‘.
 */
!define Body "!insertmacro SCHAT_MOD_BODY "
!define BodyEnd "!endif"
!macro SCHAT_MOD_BODY
  !ifdef SCHAT_DESC
    !insertmacro MUI_DESCRIPTION_TEXT ${${MOD_ID}_idx} "$(desc_${MOD_ID})"
  !endif
  !ifdef SCHAT_SECTIONS
!macroend


/*
 * Р СџР В°РЎР‚Р Р…РЎвЂ№Р Вµ Р С�Р В°Р С”РЎР‚Р С•РЎРѓРЎвЂ№ Р Т‘Р В»РЎРЏ Р С•Р В±Р Р†РЎвЂ�РЎР‚РЎвЂљР С”Р С‘ РЎРѓРЎвЂљР В°Р Р…Р Т‘Р В°РЎР‚РЎвЂљР Р…Р С•Р в„– РЎРѓР ВµР С”РЎвЂ Р С‘РЎРЏ Р Т‘Р В»РЎРЏ Р С�Р С•Р Т‘РЎС“Р В»РЎРЏ.
 * Р пїЅРЎРѓР С—Р С•Р В»РЎРЉР В·РЎС“Р ВµРЎвЂљРЎРѓРЎРЏ Р С—Р В°РЎР‚Р Р…Р С•: ${Section} Р С‘ ${SectionEnd}
 * Р С‘ Р Т‘Р С•Р В»Р В¶Р Р…РЎвЂ№ Р Р…Р В°РЎвЂ¦Р С•Р Т‘Р С‘РЎвЂљРЎРЉРЎРѓРЎРЏ Р Р†Р Р…РЎС“РЎвЂљРЎР‚Р С‘ ${Body}.
 */
!define Section "!insertmacro SCHAT_SECTION "
!macro SCHAT_SECTION
  Section "$(sec_${MOD_ID})" ${MOD_ID}_idx
    SetOverwrite on
!macroend

!define SectionEnd "!insertmacro SCHAT_SECTION_END "
!macro SCHAT_SECTION_END
  SectionEnd
!macroend


!define Uninstall "!insertmacro SCHAT_MOD_UNINSTALL "
!define UninstallEnd "!endif"
!macro SCHAT_MOD_UNINSTALL
  !ifdef SCHAT_UNINSTALL
!macroend


/*
 * Р Р€Р С—РЎР‚Р В°Р Р†Р В»РЎРЏР ВµРЎвЂљ Р Р†РЎвЂ№Р В±Р С•РЎР‚Р С•Р С� РЎРѓР ВµР С”РЎвЂ Р С‘Р С‘.
 */
!define SectionState "!insertmacro SectionState"
!macro SectionState _KEY _DEF _SEC
  Push $0
  ClearErrors
  ReadIniStr $0 "$INSTDIR\uninstall.ini" "${SCHAT_NAME}" "${_KEY}"
  ${Unless} ${Errors}
    ${If} $0 != 1
    ${AndIf} $0 != 0
      StrCpy $0 ${_DEF}
    ${EndIf}
  ${Else}
    StrCpy $0 ${_DEF}
  ${EndUnless}

  ${If} $0 == 1
    !insertmacro SelectSection ${_SEC}
  ${Else}
    !insertmacro UnselectSection ${_SEC}
  ${EndIf}

  Pop $0
!macroend


/*
 * Р РЋР С•РЎвЂ¦РЎР‚Р В°Р Р…РЎРЏР ВµРЎвЂљ РЎРѓРЎвЂљР В°РЎвЂљРЎС“РЎРѓ РЎРѓР ВµР С”РЎвЂ Р С‘Р С‘.
 */
!macro SAVE_SECTION _SEC _KEY
  ${If} ${SectionIsSelected} ${_SEC}
    WriteINIStr "$INSTDIR\uninstall.ini" "${SCHAT_NAME}" "${_KEY}" 1
  ${Else}
    WriteINIStr "$INSTDIR\uninstall.ini" "${SCHAT_NAME}" "${_KEY}" 0
  ${EndIf}
!macroend


/*
 * Р С›Р В±РЎР‚Р В°Р В±Р С•РЎвЂљР С”Р В° Р С”Р В»РЎР‹РЎвЂЎР В° Р С”Р С•Р С�Р В°Р Р…Р Т‘Р Р…Р С•Р в„– РЎРѓРЎвЂљРЎР‚Р С•Р С”Р С‘ "-update".
 * Р СџРЎС“РЎвЂљРЎРЉ РЎС“РЎРѓРЎвЂљР В°Р Р…Р С•Р Р†Р С”Р С‘ РЎРѓРЎвЂљР В°Р Р…Р С•Р Р†Р С‘РЎвЂљРЎРѓРЎРЏ Р Р…Р В° Р С•Р Т‘Р С‘Р Р… РЎС“РЎР‚Р С•Р Р†Р ВµР Р…РЎРЉ Р Р†РЎвЂ№РЎв‚¬Р Вµ РЎР‚Р В°РЎРѓР С—Р С•Р В»Р С•Р В¶Р ВµР Р…Р С‘РЎРЏ exe РЎвЂћР В°Р в„–Р В»Р В°.
 */
!macro UPDATE_CMD
  ${GetParameters} $R0
  ${GetOptionsS} $R0 "-update" $R0
  ${Unless} ${Errors}
    ${GetParent} "$EXEDIR" $R0
    StrCpy $INSTDIR $R0
    StrCpy $update true
  ${Else}
    StrCpy $update false
  ${EndUnless}
!macroend


/**
 * Р вЂ”Р В°Р Р†Р ВµРЎР‚РЎв‚¬Р В°Р ВµРЎвЂљ Р Р†РЎРѓР Вµ Р С—РЎР‚Р С•РЎвЂ Р ВµРЎРѓРЎРѓРЎвЂ№ РЎРѓ РЎС“Р С”Р В°Р В·Р В°Р Р…РЎвЂ№Р С� Р С‘Р С�Р ВµР Р…Р ВµР С�
 */
!macro KILL_ALL _NAME
 !if ${SCHAT_CHECK_RUN} == 1
  FindProcDLL::FindProc "${_NAME}"
  Pop $R0

  ${If} $R0 == 1
    ExecWait '"${_NAME}" -exit'

    ${While} $R0 == 1
      FindProcDLL::FindProc "${_NAME}"
      Pop $R0
      Sleep 100
    ${EndWhile}
  ${EndIf}
 !endif
!macroend

!endif /* SCHAT_NSH_ */
