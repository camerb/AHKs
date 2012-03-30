;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpgradeParts.ahk
;#singleinstance force
Lynx_MaintenanceType := "upgrade"

;Beginning of the actual upgrade procedure
notify("Starting Upgrade of the LynxGuide server")
SendStartMaintenanceEmail()
msg("Check to make sure you have a green messenger icon. If not, Inform level 2 support.")
TestScriptAbilities()
TestLynxSystem()
RunTaskManagerMinimized()

LynxOldVersion:=GetLynxVersion()
LynxDestinationVersion := GetLatestLynxVersion()
msg("Attempting an upgrade from Lynx Version: " . LynxOldVersion . " to " . LynxDestinationVersion)
CreateSmsKey()
PerlUpgradeNeeded:=IsPerlUpgradeNeeded()
ApacheUpgradeNeeded:=IsApacheUpgradeNeeded()

DownloadAllLynxFilesForUpgrade()

;TODO get client information and insert it into the database (if empty)
; log the info as well
CheckDatabaseFileSize()
GetServerSpecs()
GetClientInfo()
BackupLynxDatabase("BeforeUpdate")

notify("Start of Downtime", "Turning the LynxGuide Server off, in order to perform the upgrade")
TurnOffIisIfApplicable()
StopAllLynxServices()
EnsureAllServicesAreStopped()

UpgradePerlIfNeeded()
CopyInetpubFolder()
UpgradeApacheIfNeeded()
BannerDotPlx()

msg("Run perl checkdb.plx from C:\inetpub\wwwroot\cgi")
CheckDb()

RestartService("apache2.2")
SleepSeconds(2)
InstallAll()

notify("End of Downtime", "The LynxGuide Server should be back up, now we will begin the tests and configuration phase")
EnsureAllServicesAreRunning()

;another checkdb just to ensure that the system is awesome
CheckDb()

;admin login (web interface)
;TODO pull password out of DB and open lynx interface automatically
;TODO ensure all locations are described correctly
msg("(Admin Panel > Change system settings > File system locations and logging):`n`nChange logging to extensive, log age to yearly, message age to never, and log size to 500MB. Save your changes.")
msg("Ask the customer if they have a public subscription page`n`nIf not: Under Home Page and Subscriber Setup, change the home page to no_subscription.htm")
msg("Under back up system, set file system backups quarterly and database backups weekly")
InstallSmsKey()

;security login (web interface)
;TODO pull password out of DB and open lynx interface automatically
msg("Ensure lynx2@mitsi.com is added in the contact list, with the comment 'Lynx Technical Support - Automated Supervision'")
msg("Send Test SMS message, popup (to server), and email (to lynx2).")
LynxNewVersion := GetLynxVersion()
TestLynxSystem()
SendLogsHome()
msg("Disable 000 Supervision on Alarm Groups POPUP and LYNXKEYPRO, if they do not have any destinations set up.")
msg("Ensure the LynxGuide supervision channels 000 Normal, 000 Alarm, 001, 002, 006, 007, 008, 009 are enabled, with the company name in the subject line of each alarm message.")
msg("Ensure lynx2 is a contact for the LynxGuide channels 000 Normal, 000 Alarm, 001, 002, 009")
msg("For all hardware alarm groups, ensure lynx2 is a contact on 000 Normal, 000 Alarm and 990")

;testing
;msg("Note in sugar: Tested SMS and Email to lynx2@mitsi.com, failed/passed by [initials] mm-dd-yyyy")
;msg("Note server version, last updated in sugar")
;msg("Make case in sugar for 'Server upgraded to 7.##.##.#', note specific items/concerns addressed with customer in description")

BackupLynxDatabase("AfterUpdate")
ShowUpgradeSummary()
msg("Log off of the server")
SleepMinutes(60*12)
Shutdown, 4
ExitApp


;TODO do all windows updates (if their server is acting funny)
;  this is a bad idea cause it will require a reboot

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; functions

;ghetto hotkey
Appskey & r::
SetTitleMatchMode, 2
WinActivate, Notepad
WinWaitActive, Notepad
Sleep, 200
Send, {ALT}fs
Sleep, 200
reload
return


msg(message)
{
   message .= "`n`nLynx Maintenance has been paused. Click OK once you have performed the action specified above."
   lynx_log("Message displayed to technician...`n" . message)
   MsgBox, , Lynx Upgrade Assistant, %message%
}

LynxError(message)
{
   msg("ERROR: " . message)
}

;Returns a true or false, confirming that they did or didn't complete this step
;ConfirmMsgBox(message)
;{
   ;title=Lynx Install

   ;MsgBox, 4, %title%, %message%
   ;IfMsgBox, Yes
      ;return true
   ;else
      ;return false
;}

;TODO get important info and condense into a summary
;importantLogInfo(message)
;{
;}

IsPerlUpgradeNeeded()
{
   version := GetPerlVersion()

   if (version == "5.8.9")
      returned := false
   else
      returned := true

   delog(A_ThisFunc, "Determined if the update was needed (next line)", returned, version)
   return returned
}

IsApacheUpgradeNeeded()
{
   version := GetApacheVersion()

   if (version == "2.2.22")
      returned := false
   else if (version == "2.2.21")
      returned := false
   else
      returned := true

   delog(A_ThisFunc, "Determined if the update was needed (next line)", returned, version)
   return returned
}

GetLatestLynxVersion()
{
   DownloadLynxFile("version.txt")
   returned := FileRead("C:\temp\lynx_upgrade_files\version.txt")
   return returned
}

EnsureApacheServiceNotExist()
{
   serviceName:="apache2.2"
   ret := CmdRet_RunReturn("sc query " . serviceName)
   if NOT InStr(ret, "service does not exist")
      msg("ERROR: An apache service exists, inform level 2 support")
}

AddSqlConnectStringFiles()
{
   ;path=C:\inetpub\
   source1=C:\inetpub\tools\sql.txt
   source2=C:\inetpub\tools\sql2.txt
   dest1=C:\inetpub\sql.txt
   dest2=C:\inetpub\sql2.txt

   if NOT FileExist(dest1)
      FileCopy(source1, dest1)
   if NOT FileExist(dest2)
      FileCopy(source2, dest2)
}

