#include FcnLib.ahk
#include SendEmailSimpleLib.ahk

logFile=C:\My Dropbox\Public\logs\%A_ComputerName%.txt

Gui, Add, Text,, Welcome to the Lynx Server Installer
Gui, Add, Text,, Please select the components you would like to install:

Gui, Add, Checkbox, Checked vChoseCopyInstallationFilesToHardDrive, Copy Installation Files
Gui, Add, Checkbox, Checked vChoseTurnOffWindowsFirewall, Turn Off Windows Firewall
Gui, Add, Checkbox,         vChoseChangeScreenResolution, Change Screen Resolution
Gui, Add, Checkbox, Checked vChoseActivePerl, ActivePerl
Gui, Add, Checkbox, Checked vChoseSSMS, SSMS
Gui, Add, Checkbox, Checked vChoseApache, Apache
Gui, Add, Checkbox, Checked vChoseTTS, Text-to-Speech
Gui, Add, Checkbox, Checked vChoseIIS, IIS
Gui, Add, Checkbox, Checked vChoseMakeDesktopShortcuts, Make Desktop Shortcuts
Gui, Add, Checkbox, Checked vChoseLynxMessenger, Lynx Messenger
Gui, Add, Checkbox, Checked vChoseEnableIISlocalhostRelay, Enable IIS Localhost Relay
Gui, Add, Checkbox, Checked vChoseChangeDesktopBackground, Change Desktop Background

Gui, Add, Button, Default, Install
Gui, Show
return

ButtonInstall:
Gui, Submit
Gui, Destroy

if (A_ScreenWidth > 1280)
   delog("", "WARNING: The Lynx Server Install is designed to run on the physical machine, is appears as if you are running the script while logged in through Remote Desktop. The installation will continue, but proceed carefully.`n`nPress ESC at any time to cancel.")

debug("Starting Lynx Server Installation`n`nPress ESC at any time to cancel.")

if ChoseCopyInstallationFilesToHardDrive
   CopyInstallationFilesToHardDrive()
if ChoseTurnOffWindowsFirewall
   TurnOffWindowsFirewall()
if ChoseChangeScreenResolution
   ChangeScreenResolution()
if ChoseActivePerl
   InstallActivePerl()
if ChoseSSMS
{
   InstallSSMS()
   ConfigureSSMS()
   SleepSeconds(200)
   TestBannerDotPlx()
}
if ChoseApache
{
   ConfigureW3SVCservice()
   InstallApache()
}
if ChoseTTS
{
   ConfigureAudioSrvService()
   InstallAllTTS()
}
if ChoseIIS
   InstallIIS()
if ChoseMakeDesktopShortcuts
   MakeDesktopShortcuts()
if ChoseLynxMessenger
   InstallLynxMessenger()
if ChoseEnableIISlocalhostRelay
   EnableIISlocalhostRelay()
if ChoseChangeDesktopBackground
   ChangeDesktopBackground()

;things that always need to be done
;  (do things that are likely to fail towards the top)
TestBannerDotPlx()
SendEmailSimple("Lynx Install Finishing", "this lynx install is finishing up right now, here are the logs", logfile)
FileCopy(logfile, "C:\inetpub\logs\LynxInstallLog_ahk.txt", "overwrite")
FileRemoveDir, C:\My Dropbox, 1

MsgBox, Finished with Lynx Server Install
ExitApp ;end of install

;if they hit the x then close
GuiClose:
ExitApp

ESC::ExitApp

AppsKey & d::
Gui, Destroy
debug("log", "starting debug script")
WinLogActiveStats(A_ThisFunc, A_LineNumber)
SendEmailSimple("Test Message", A_ComputerName, logfile)
debug("log", "finished debug script")
ExitApp

#include Lynx-InstallParts.ahk
#include Lynx-FcnLib.ahk
