#############################################################
# AUTHOR: Kurt Tometich
# DATE: Aug 26, 2006
#
# BRIEF:
#  This NSIS script creates an executable
#  install file:"TsTool_version_setup.exe"
#  This .exe install file will setup TsTool
#  programs and allow the user to choose
#  from certain components to install
#
# COMPONENTS:
#  BaseComponents - base jar files in CDSS\bin
#  Documentation  - pdf's and text files for this release
#  TsTool - installs TsTool specific files (jars, bats, etc)
#  Start Menu Shortcuts - installs shortcuts to run TsTool
#                          and uninstall TsTool
#  DesktopShortcut - should be self explanatory
#
##############################################################

Name TSTool
# Defines
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 3.08.02
!define COMPANY RTi
!define URL http://www.riverside.com

# Included files
!include Sections.nsh
!include MUI.nsh
!include ..\externals\NSIS_Common\Util.nsh
!include ..\externals\CDSS\installer\BaseComponents.nsh
!include ..\externals\CDSS\installer\server_name.nsh

# Reserved Files
ReserveFile "${NSISDIR}\Plugins\StartMenu.dll"

# Variables
Var StartMenuGroup
Var myInstDir
Var choseTSTool

# Installer pages
Page license
Page components
Page directory
Page custom StartMenuGroupSelect "" ": Start Menu Folder"
Page instfiles
Page custom SetCustom

# Installer attributes
OutFile TSTool_Setup.exe
InstallDir C:\CDSS
CRCCheck on
XPStyle on
Icon "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
ShowInstDetails show
AutoCloseWindow false
LicenseForceSelection radiobuttons
LicenseData ..\doc\TSTool\License.txt
BGGradient 220099 000000 FFFFFF
VIProductVersion 6.18.0.0
VIAddVersionKey ProductName TSTool
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion ""
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
ShowUninstDetails show


##################################################################
# SECTION: -setSharedInstallDir
# 
# initializes some global variables
#   myInstDir - users chosen install directory
#   choseTSTool - Used for dependencies in later sections
#                0 = user chose not to install TSTool,
#                1 = user chose to install TSTool
#  
# BRIEF:
#  The minus sign at the beginning of the section name
#  is used to make this a hidden section to the user
#  this means they cannot choose to not run it
###################################################################
Section -setSharedInstallDir
    strcpy $myInstDir $INSTDIR
    strcpy $choseTSTool "0"
SectionEnd


# MUI defines
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY Software\CDSS
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULT_FOLDER CDSS
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\rti.bmp" ; optional
!define MUI_ABORTWARNING


# Installer languages
!insertmacro MUI_LANGUAGE English

########################################################
# SECTION: -Main
# 
# BRIEF:
#  used to write the Reg Key for the components
########################################################
Section -Main
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd


#########################################
# SECTION: Documentation
#
# BRIEF:
#  Installs current documentation   
#  for TSTool to C:\CDSS\doc\TSTool
#
# The /o stands for optional.  This
# allows the component page to uncheck
# this box by default.   
#########################################
Section /o "Documentation"
    
    # copy documentation
    SetOutPath $INSTDIR\doc\TSTool
    SetOverwrite on
    File /r /x *svn* ..\doc\TSTool\*

SectionEnd


##################################################
# SECTION: TSTool
#
# BRIEF: 
#  Installs the TSTool specific files.
#  These may change each release so
#  the files included may need to be 
#  updated.  Before each file is placed
#  on the users machine it is checked
#  to make sure we don't overwrite
#  a newer or current version.  Each
#  file is checked with a Utility function
#  located in Util.nsh:CompareFileModificationDates  
#
##################################################
Section "TSTool"

    # set choseTSTool variable to true since it was chosen
    strcpy $choseTSTool "1"
    
    # copy important bat/jar files specific to this product
    SetOverwrite on
    SetOutPath $INSTDIR\bin
    
    # check access date/time
    strcpy $9 "TSTool_142.jar"
    strcpy $cur_file "C:\CDSS\bin\$9"
    strcpy $install_file "..\dist\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\bin\$9 is current"
      Goto +2
      File ..\dist\TSTool_142.jar
    
    # check access date/time
    strcpy $9 "TSTool.cfg"
    SetOutPath $INSTDIR\system
    strcpy $cur_file "$INSTDIR\$9"
    strcpy $install_file "..\test\operational\CDSS\system\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\$9 is current"
      Goto +2
    File ..\test\operational\CDSS\system\TSTool.cfg
  
    
    ########## TSTool BAT FILES ############  
    
    # check access date/time
    strcpy $9 "TSTool.bat"
    SetOutPath "$INSTDIR\bin"
    strcpy $cur_file "$INSTDIR\bin\$9"
    strcpy $install_file "..\scripts\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\bin\$9 is current"
      Goto +2
      File ..\scripts\TSTool.bat
    
    
    # check access date/time
    strcpy $9 "NWSRFS_DMI_142.jar"
    SetOutPath "$INSTDIR\bin"
    strcpy $cur_file "$INSTDIR\bin\$9"
    strcpy $install_file "..\externals\NWSRFS_DMI\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\bin\$9 is current"
      Goto +2
      File ..\externals\NWSRFS_DMI\NWSRFS_DMI_142.jar
    
    # check access date/time
    strcpy $9 "RiversideDB_DMI_142.jar"
    SetOutPath "$INSTDIR\bin"
    strcpy $cur_file "$INSTDIR\bin\$9"
    strcpy $install_file "..\externals\RiversideDB_DMI\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\bin\$9 is current"
      Goto +2
      File ..\externals\RiversideDB_DMI\RiversideDB_DMI_142.jar
    
    # check access date/time
    strcpy $9 "StateMod_142.jar"
    SetOutPath "$INSTDIR\bin"
    strcpy $cur_file "$INSTDIR\bin\$9"
    strcpy $install_file "..\externals\StateMod\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\bin\$9 is current"
      Goto +2
      File ..\externals\StateMod\StateMod_142.jar
    
    # check access date/time
    strcpy $9 "StateCU_142.jar"
    SetOutPath "$INSTDIR\bin"
    strcpy $cur_file "$INSTDIR\bin\$9"
    strcpy $install_file "..\externals\StateCU\$9"
    Call CompareFileModificationDates
    strcmp "0" $AccessReturnVal +3 0
      DetailPrint "Local version $INSTDIR\bin\$9 is current"
      Goto +2
      File ..\externals\StateCU\StateCU_142.jar
    
    
   ############################################
   
    # add README
    SetOutPath $INSTDIR
    File ..\conf\TSTool_README.txt
    
    # Installs shortcut in $INSTDIR
    SetOutPath $INSTDIR\bin
    CreateShortCut "$INSTDIR\TSTool.lnk" "$INSTDIR\jre_142\bin\javaw.exe" "-Xmx256m -cp $\"HydroBaseDMI_142.jar;msbase.jar;mssqlserver.jar;msutil.jar;RTi_142.jar;NWSRFS_DMI_142.jar;RiversideDB_DMI_142.jar;StateMod_142.jar;StateCU_142.jar;TSTool_142.jar$\" DWR.DMI.tstool.tstool -home ../ "C:\CDSS\graphics\waterMark.bmp""
    
SectionEnd


##############################################
# SECTION: Start Menu Shortcuts
#
# BRIEF: 
#  This section creates the start -> apps
#  shortcuts as CDSS -> TSTool -> uninstall
#                             -> run TSTool
#  
##############################################
Section "Start Menu Shortcuts"

    # make sure user chose to install TSTool
    strcmp $choseTSTool "0" 0 +2
      Goto skipMenu
    
    # Shortcut for uninstall of program
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall_TSTool.exe
    
    # Shortcut added for launch of java program
    SetOutPath $INSTDIR\bin
    CreateShortCut "$SMPROGRAMS\$StartMenuGroup\Run TSTool.lnk" "$INSTDIR\jre_142\bin\javaw.exe" "-Xmx256m -cp $\"HydroBaseDMI_142.jar;msbase.jar;mssqlserver.jar;msutil.jar;RTi_Common_142.jar;NWSRFS_DMI_142.jar;RiversideDB_DMI_142.jar;StateMod_142.jar;StateCU_142.jar;TSTool_142.jar$\" DWR.DMI.tstool.tstool -home ../ "C:\CDSS\graphics\waterMark.bmp""
    
    skipMenu:
    
SectionEnd


############################################
# SECTION: DesktopShortcut
#
# BRIEF:
#  should be pretty obvious what this does.
#  If its not, you shouldn't be reading this
#  
############################################
Section /o "DesktopShortcut"

    # make sure user chose to install TSTool
    strcmp $choseTSTool "0" 0 +2
      Goto skipShortcut
   
    # Installs shortcut on desktop
    SetOutPath $INSTDIR\bin
    CreateShortCut "$DESKTOP\TSTool.lnk" "$INSTDIR\jre_142\bin\javaw.exe" "-Xmx256m -cp $\"HydroBaseDMI_142.jar;msbase.jar;mssqlserver.jar;msutil.jar;RTi_Common_142.jar;NWSRFS_DMI_142.jar;RiversideDB_DMI_142.jar;StateMod_142.jar;StateCU_142.jar;TSTool_142.jar$\" DWR.DMI.tstool.tstool -home ../ "C:\CDSS\graphics\waterMark.bmp""

    skipShortcut:

SectionEnd


###############################################
# SECTION: -post SEC0001
#
# BRIEF: 
#  writes some registry keys and values for 
#  functionality of add/remove programs
###############################################
Section -post SEC0001
    
    # make sure user chose to install TSTool
    strcmp $choseTSTool "0" 0 +2
      Goto skipPost
    
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    WriteRegStr HKLM "${REGKEY}" StartMenuGroup $StartMenuGroup
    SetOverwrite off
    CreateDirectory "$INSTDIR\Uninstall"
    WriteUninstaller $INSTDIR\Uninstall\Uninstall_TSTool.exe
    
    #!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\Uninstall\Uninstall_TSTool.exe
    #!insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\Uninstall\Uninstall_TSTool.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\Uninstall\Uninstall_TSTool.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
    
    skipPost:
    
SectionEnd


# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend



####### Uninstaller sections  #######

######################################################
# SECTION: /o un.Main UNSEC0000
#
# BRIEF: the coolest section name ever....
#  uninstall method that deletes TSTool specific files
#  when user chooses to execute uninstall
######################################################
Section /o un.Main UNSEC0000
    
    Delete /REBOOTOK $INSTDIR\bin\TSTool.bat
    Delete /REBOOTOK $INSTDIR\bin\TSTool_rti.bat
    Delete /REBOOTOK $INSTDIR\bin\NWSRFS_DMI_142.jar
    Delete /REBOOTOK $INSTDIR\bin\RiversideDB_DMI_142.jar
    Delete /REBOOTOK $INSTDIR\bin\StateMod_142.jar
    Delete /REBOOTOK $INSTDIR\bin\StateCU_142.jar
    Delete /REBOOTOK $INSTDIR\bin\TSTool_142.jar
    RmDir /r /REBOOTOK $INSTDIR\doc\TSTool
    Delete /REBOOTOK $INSTDIR\system\TSTool.cfg
    Delete /REBOOTOK $INSTDIR\TSTool_README.txt
    DeleteRegValue HKLM "${REGKEY}\Components" Main
    
    
SectionEnd

#####################################################
# SECTION: un.post UNSEC0001
#
# BRIEF:
#  runs post-uninstall.  Deletes some registry
#  settings and start menu junk
#####################################################
Section un.post UNSEC0001
    
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Run TSTool.lnk"
    Delete /REBOOTOK "$INSTDIR\TSTool.lnk"
    Delete /REBOOTOK "$DESKTOP\TSTool.lnk"
    Delete /REBOOTOK $INSTDIR\Uninstall\Uninstall_TSTool.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $SMPROGRAMS\CDSS
    RmDir /REBOOTOK $INSTDIR\Uninstall
    RmDir /REBOOTOK $INSTDIR\doc
    
SectionEnd

#################################################
# FUNCTION: StartMenuGroupSelect
#
# BRIEF:
#  has the info for the start menu page that the
#  user see's during installation.  
#################################################
Function StartMenuGroupSelect
    Push $R1
    StartMenu::Select /autoadd /text "Select the Start Menu folder in which you would like to create the program's shortcuts:" /lastused $StartMenuGroup CDSS\TSTool
    Pop $R1
    StrCmp $R1 success success
    StrCmp $R1 cancel done
    MessageBox MB_OK $R1
    Goto done
success:
    Pop $StartMenuGroup
done:
    Pop $R1
FunctionEnd

################################################
# FUNCTION: .onInstSuccess
#
# BRIEF: NSIS default function
#  When installation is successful and the
#  user clicks the close button, this function
#  is called.  It prompts the user to execute
#  the program and view the readme
################################################
Function .onInstSuccess

    SetOutPath $INSTDIR\bin
    
    # if 0 then user didn't choose to install TSTool
    strcmp $choseTSTool "0" 0 +2
      Goto skipThis
    
    MessageBox MB_YESNO "Would you like to run the program?" IDYES true IDNO false
    true:
      Exec '"$INSTDIR\jre_142\bin\javaw.exe" -Xmx256m -cp $\"HydroBaseDMI_142.jar;msbase.jar;mssqlserver.jar;msutil.jar;RTi_Common_142.jar;NWSRFS_DMI_142.jar;RiversideDB_DMI_142.jar;StateMod_142.jar;StateCU_142.jar;TSTool_142.jar$\" DWR.DMI.tstool.tstool -home ../'
      Goto next
    false:
      DetailPrint "User chose to not start application"
    next:
    
    MessageBox MB_YESNO "Would you like to view the README?" IDYES yes IDNO no
    yes:
      Exec 'notepad.exe $INSTDIR\TSTool_README.txt'
      Goto next2
    no:
      DetailPrint "Skipping README"
    next2:
    
    skipThis:
    
FunctionEnd


########################################
# FUNCTION: .onInit
#
# BRIEF: NSIS default function
#  executes on Init of Outfile created
#
########################################
Function .onInit
    
    InitPluginsDir
    
FunctionEnd


###########################################
# FUNCTION: un.onInit
#
# BRIEF: NSIS default function
#  runs on Init of the unistall.exe  
#  makes sure the user wants to uninstall
#
###########################################
Function un.onInit  
    
    ### Prompt the user for uninstall ###
    MessageBox MB_YESNO "Are you sure you want to remove this program?" IDYES true IDNO false
    true:
      Goto next
    false:
      MessageBox MB_OK "Program removal aborted"
      Quit
    next:
    
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    ReadRegStr $StartMenuGroup HKLM "${REGKEY}" StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd