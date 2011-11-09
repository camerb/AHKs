#singleinstance force



;Beginning of the actual script
LynxOldVersion:=GetLynxVersion()

msg("Attempting an upgrade from Lynx Version: " . LynxOldVersion)
msg("Download 7.11.zip server code from the web")

PerlOldVersion:=GetPerlVersion()
PerlUpgradeNeeded:=IsPerlUpgradeNeeded()
msg("Check the perl version to ensure that it is not older than 5.8.9")
msg("If the perl version is older than 5.8.9, download the new perl")

msg("Create the SMS key")
RunTaskMgrMinimized() ;Open task manager and minimize it
CheckDatabaseFileSize()
GetServerSpecs()
msg("Enter client data from Lynx Database into Sugar")
msg("Backup Lynx database")

msg("Turn off IIS, change port to 8081, turn off app pools")
msg("Turn off apache")
msg("Run perl start-msg-service.pl removeall")


if PerlUpgradeNeeded
{
   msg("Uninstall perl")
   ;UNCOMMENTME FileDeleteDir("C:\Perl")
   msg("Install new perl")
}

msg("Copy the contents of the zip files into C:\inetpub")
msg("If sql.txt or sql2.txt are not in the inetpub folder, then add them from \tools\")
msg("Install apache")
msg("Run perl banner.plx")
msg("Run perl checkdb.plx")
msg("Restart apache services`n(wait until complete before performing the next step)")
msg("Run perl start-msg-service.pl installall")

;admin login (web interface)
msg("Open the web interface, log in as admin, Install the new SMS key")
msg("under change system settings, then under file system locations and logging change logging to extensive, log age to yearly, message age to never, and log size to 500MB. Save your changes")
msg("Ask the customer if they have a public subscription page, and if not: Under Home Page and Subscriber Setup, change the home page to no_subscription.htm")
msg("Under back up system, set system backups monthly and database backups weekly")

msg("Restart the services one at a time in the Apache control services manager")

;security login (web interface)
msg("Add the four LynxGuide supervision channels: 000 Normal, 006, 007, 008, 009")
msg("Add lynx2.mitsi.com to the LynxGuide channels 000 Normal, 000 Alarm, 001, 002, 003, 009")
msg("Add 000 Normal, supervision restored for all hardware alarm groups")
msg("Add lynx2@mitsi.com to 000 Alarm, 000 Normal and 990")

;TODO do all windows updates (if their server is acting funny)

;testing
msg("Send Test SMS message, popup (to server), and email (to lynx2).")
msg("Note in sugar: Tested SMS and Email to lynx2@mitsi.com, failed/passed by [initials] mm-dd-yyyy")

msg("Note server version, last updated in sugar")
msg("Make case in sugar for 'Server Software Upgrade', note specific items/concerns addressed with customer in description")

LynxNewVersion := GetLynxVersion()
ShowUpgradeSummary()


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


;Returns a true or false, confirming that they did or didn't complete this step
ConfirmMsgBox(message)
{
   title=Lynx Install
   
   MsgBox, 4, %title%, %message%
   IfMsgBox, Yes
      return true
   else
      return false
}

msg(message)
{
   MsgBox, , Lynx Upgrade Assistant, %message%
}

importantLogInfo()
{
}

logInfo()
{
}

;WRITEME
DownloadInstallationFile(filename, unzipDestination)
{

}

RunTaskMgrMinimized()
{
   Run, taskmgr
   WinWait, Windows Task Manager
   WinMinimize
}

GetServerSpecs()
{
   Loop 4
   {
      thisIP := A_IPaddress%A_Index%
      if (thisIP != "0.0.0.0")
         IPlist .= "`n" . thisIP
   }
   msg=The server's IP addresses are: %IPlist%`nPlease enter this info into Sugar
   msg(msg)
   
   Run, control /name Microsoft.System
   WinWait, System
   Sleep, 1000
   ;UNCOMMENTME SaveScreenShot("serverSpecs", "C:\inetpub\logs\lynxUpgrades\", "activeWindow")
   msg("Enter server Computer Name, RAM, Processor Speed and OS into Sugar")
   WinClose, System
}

GetPerlVersion()
{
   ;UNCOMMENTME output:=CmdRet_RunReturn("perl -v")
   RegExMatch(output, "v[0-9.]*", match)
   return match
}

IsPerlUpgradeNeeded()
{
   if (GetPerlVersion() != "v5.8.9")
      return true
   else
      return false
}

GetLynxVersion()
{
   versionFile=C:\inetpub\version.txt
   if NOT FileExist(versionFile)
      returned=lynx-old-build
   else
      FileRead, returned, %versionFile%

   return returned
}

ShowUpgradeSummary()
{
   global LynxOldVersion
   global LynxNewVersion
   msg=Upgraded server from %LynxOldVersion% to %LynxNewVersion%
   msg(msg)
}

CheckDatabaseFileSize()
{
msg("Check database file size to ensure it is smaller than 200MB")
}