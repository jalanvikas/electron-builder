Var startMenuLink
Var desktopLink

!include "common.nsh"
!include "MUI2.nsh"
!include "multiUser.nsh"
!include "allowOnlyOneInstallerInstance.nsh"

!ifdef INSTALL_MODE_PER_ALL_USERS
  !ifdef BUILD_UNINSTALLER
    RequestExecutionLevel user
  !else
    RequestExecutionLevel admin
  !endif
!else
  RequestExecutionLevel user
!endif

!ifdef ONE_CLICK
  !include "oneClick.nsh"
!else
  !include "boringInstaller.nsh"
!endif

!ifmacrodef customHeader
  !insertmacro customHeader
!endif

!ifdef BUILD_UNINSTALLER
  SilentInstall silent
!else
  Var appExe
!endif

Function .onInit
  ; Installtion of CollaborateService (preInit) is moved to "install" section
  
  !ifdef BUILD_UNINSTALLER
    WriteUninstaller "${UNINSTALLER_OUT_FILE}"
    !insertmacro quitSuccess
  !else
    !insertmacro check64BitAndSetRegView

    !ifdef ONE_CLICK
      !insertmacro ALLOW_ONLY_ONE_INSTALLER_INSTANCE
    !else
      ${IfNot} ${UAC_IsInnerInstance}
        !insertmacro ALLOW_ONLY_ONE_INSTALLER_INSTANCE
      ${EndIf}
    !endif

    !insertmacro initMultiUser

    !ifmacrodef customInit
      !insertmacro customInit
    !endif
  !endif
FunctionEnd

!ifndef BUILD_UNINSTALLER
  !include "installUtil.nsh"
!endif

Section "install"
  !ifndef BUILD_UNINSTALLER
    !include "installSection.nsh"
  !endif
  !ifmacrodef preInit
    !insertmacro preInit
  !endif
  BringToFront
SectionEnd

!ifdef BUILD_UNINSTALLER
  !include "uninstaller.nsh"
!endif