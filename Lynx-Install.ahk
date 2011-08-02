#include FcnLib.ahk

;if (A_ScreenWidth > 1280)
   ;errord("nolog", "WARNING: The Lynx Server Install is designed to run on the physical machine, is appears as if you are running the script while logged in through Remote Desktop. The installation will continue, but proceed carefully.`n`nPress ESC at any time to cancel.")

debug("Starting Lynx Server Installation`n`nPress ESC at any time to cancel.")
CopyInstallationFilesToHardDrive()
TurnOffWindowsFirewall()
ChangeScreenResolution()
SleepSeconds(20)
InstallActivePerl()
SleepSeconds(20)
InstallSSMS()
SleepSeconds(20)
ConfigureSSMS()
SleepSeconds(20)
TestBannerDotPlx()
SleepSeconds(20)
ConfigureW3SVCservice()
InstallApache()
SleepSeconds(20)
ConfigureAudioSrvService()
InstallAllTTS()
SleepSeconds(20)
InstallIIS()
SleepSeconds(20)
MakeDesktopShortcuts()
InstallLynxMessenger()
EnableIISlocalhostRelay()
ChangeDesktopBackground()
FileRemoveDir, C:\My Dropbox, 1
MsgBox, Finished with Lynx Server Install

ExitApp
ESC::ExitApp

#include Lynx-FcnLib.ahk
