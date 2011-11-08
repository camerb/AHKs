#include FcnLib.ahk

logFile=C:\Dropbox\Public\logs\%A_ComputerName%.txt

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
Gui, Add, Checkbox, Checked vChoseInstallAllServices, Install All Services
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
delog("Starting Lynx Server Installation (In-house Installer)")

;TODO send email status message
;SendEmailNow("Lynx Install Starting", "there is a lynx install that is starting up right now")

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
if ChoseInstallAllServices
   InstallAllServices()
if ChoseEnableIISlocalhostRelay
   EnableIISlocalhostRelay()
if ChoseChangeDesktopBackground
   ChangeDesktopBackground()

;things that always need to be done
;  (do things that are likely to fail towards the top)
TestBannerDotPlx()
SendEmailNow("Lynx Install Finishing", "a lynx install is finishing up now, here are the logs", logfile)

MsgBox, Finished with Lynx Server Install
ExitApp ;end of install

;if they hit the x then close
GuiClose:
ExitApp

ESC::ExitApp

AppsKey & d::
Gui, Destroy

;blah blah ==========
debug("log", "Check to ensure the logs have been placed in C:\inetpub\logs\")
exitapp
;blah blah delete this area ^^^^^^^^^^^

debug("log", "starting debug script")
Loop 100
   InstallAllServices()

Loop 100
{
   ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
   if NOT ret
      nullsCount++
}
debug("errord", "nulls count", nullsCount)

ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
debug("errord", ret)
WinLogActiveStats(A_ThisFunc, A_LineNumber)
SendEmailNow("Test Message", A_ComputerName, logfile)
debug("log", "finished debug script")
CleanUpAfterLynxInstall()
ExitApp

#include Lynx-InstallParts.ahk
#include Lynx-FcnLib.ahk
