;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
;#singleinstance force
Lynx_MaintenanceType := "upgrade"

;SendLogsHome()
;Sleep, 10000
;ExitApp

;Beginning of the actual script
notify("Starting Upgrade of the LynxGuide server")
SendStartMaintenanceEmail()
TestScriptAbilities()
RunTaskManagerMinimized()
LynxOldVersion:=GetLynxVersion()
;TODO get client information and insert it into the database (if empty)
; log the info as well

LynxDestinationVersion := GetLatestLynxVersion()
msg("Attempting an upgrade from Lynx Version: " . LynxOldVersion . " to " . LynxDestinationVersion)

DownloadAllLynxFilesForUpgrade()

PerlUpgradeNeeded:=IsPerlUpgradeNeeded()
ApacheUpgradeNeeded:=IsApacheUpgradeNeeded()

msg("Ensure the SMS key is being created.")
CheckDatabaseFileSize()
GetServerSpecs()
GetClientInfo()
msg("Backup Lynx database")

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

;admin login (web interface)
;TODO pull password out of DB and open lynx interface automatically
msg("Open the web interface, log in as admin, Install the new SMS key")
msg("under change system settings, then under file system locations and logging change logging to extensive, log age to yearly, message age to never, and log size to 500MB. Save your changes")
msg("Ask the customer if they have a public subscription page, and if not: Under Home Page and Subscriber Setup, change the home page to no_subscription.htm")
msg("Under back up system, set system backups monthly and database backups weekly")

;security login (web interface)
;TODO pull password out of DB and open lynx interface automatically
msg("Send Test SMS message, popup (to server), and email (to lynx2).")
SendLogsHome()
msg("Add the four LynxGuide supervision channels: 000 Normal, 006, 007, 008, 009")
msg("Add lynx2.mitsi.com to the LynxGuide channels 000 Normal, 000 Alarm, 001, 002, 003, 009")
msg("Add 000 Normal, supervision restored for all hardware alarm groups")
msg("Add lynx2@mitsi.com to 000 Alarm, 000 Normal and 990")

;testing
;msg("Note in sugar: Tested SMS and Email to lynx2@mitsi.com, failed/passed by [initials] mm-dd-yyyy")
;msg("Note server version, last updated in sugar")
;msg("Make case in sugar for 'Server upgraded to 7.##.##.#', note specific items/concerns addressed with customer in description")

LynxNewVersion := GetLynxVersion()
ShowUpgradeSummary()
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


GetClientInfo()
{
   ;TODO need to filecreate the perl code to client_info.plx

   ret := CmdRet_Perl("client_info.plx")
   ret := StringReplace(ret, "`t", "  `t  ")
   if InStr(ret, "LynxMessageService") ;TODO perhaps check if a tab is in there... that would be more generic
      msg("Enter client data from Lynx Database into Sugar`n`n" . ret)
   else
   {
      Clipboard=SELECT [type],[ver],count(*) FROM[ipaddress] GROUP BY [type],[ver]
      msg("Get the client data and put it into Sugar. The database query has been placed on the clipboard, so just paste it into SSMS to run it")
      lynx_log("I think this is an error: Tried to get client data from the database, but got this instead: " . ret)
   }
}

msg(message)
{
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

EnsureAllServicesAreStopped()
{
   Sleep, 5000
   ;FIXME - make this an error, not a log
   if NOT AllServicesAre("stopped")
      lynx_log("Not all services are stopped")
}

EnsureAllServicesAreRunning()
{
   Sleep, 5000
   ;FIXME - make this an error, not a log
   if NOT AllServicesAre("running")
      lynx_log("Not all services are running")
}

;TODO get important info and condense into a summary
;importantLogInfo(message)

UnzipInstallPackage(file)
{
   notify("unzipping install package")
   ;7z=C:\temp\lynx_upgrade_files\7z.exe
   p=C:\temp\lynx_upgrade_files
   folder:=file
   ;cmd=%7z% a -t7z %p%\archive.7z %p%\*.txt
   cmd=%p%\unzip.exe %p%\%file%.zip -d %p%\%folder%
   CmdRet_RunReturn(cmd, p)
   notify("finished unzipping install package")
}

;WRITEME
DownloadLynxFile(filename)
{
   global downloadPath

   TestDownloadProtocol("ftp")
   TestDownloadProtocol("http")

   destinationFolder=C:\temp\lynx_upgrade_files
   url=%downloadPath%/%filename%
   dest=%destinationFolder%\%filename%

   FileCreateDir, %destinationFolder%
   UrlDownloadToFile, %url%, %dest%

   ;TODO perhaps we want to unzip the file now (if it is a 7z)
   if RegExMatch(filename, "^(.*)\.zip$", match)
      UnzipInstallPackage(match1)
}

TestDownloadProtocol(testProtocol)
{
   global connectionProtocol
   global downloadPath

   if connectionProtocol
      return ;we already found a protocol, so don't run the test again

   ;prepare for the test
   pass:=GetLynxPassword("generic")
   if (testProtocol == "ftp")
      downloadPath=ftp://update:%pass%@lynx.mitsi.com/upgrade_files
   else if (testProtocol == "http")
      downloadPath=http://update:%pass%@lynx.mitsi.com/Private/techsupport/upgrade_files

   ;test it
   url=%downloadPath%/test.txt
   joe:=UrlDownloadToVar(url)

   ;determine if the test was successful
   if (joe == "test message")
      connectionProtocol:=testProtocol
}

CopyInetpubFolder()
{
   notify("Copying the contents of the inetpub folder")
   FileCopyDir("C:\temp\lynx_upgrade_files\upgrade_pack\inetpub", "C:\Inetpub", "overwrite")
   AddSqlConnectStringFiles()
   notify("finished copying inetpub folder")
}

RunTaskManagerMinimized()
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

TurnOffIisIfApplicable()
{
   if NOT GetApacheVersion() ;Apache is not installed, must be IIS
      msg("Turn off IIS, change port to 8081, turn off app pools")
}

UpgradePerlIfNeeded()
{
   if IsPerlUpgradeNeeded()
   {
      msg("Uninstall perl")
      while GetPerlVersion()
         lynx_error("Uninstall perl")

      oldPerlDir:="C:\Perl-old-" . CurrentTime("hyphenated")
      ;FileDeleteDirForceful("C:\Perl")
      FileMoveDir, "C:\Perl", oldPerlDir

      Run, C:\temp\lynx_upgrade_files\upgrade_pack\ActivePerl\ActivePerl.msi
      Sleep, 2000
      msg("Install new perl")
      while IsPerlUpgradeNeeded()
         lynx_error("Install new perl")

      FileDeleteDirForceful(oldPerlDir)
   }
}

UpgradeApacheIfNeeded()
{
   if IsApacheUpgradeNeeded()
   {
      msg("Uninstall apache")
      while GetApacheVersion()
         lynx_error("Uninstall apache")
      ;TODO wait for the finished page of the installer
      ;ensure the service is gone
      EnsureApacheServiceNotExist()

      Run, C:\temp\lynx_upgrade_files\upgrade_pack\apache\apache.msi
      Sleep, 2000
      msg("Install new apache")
      while IsApacheUpgradeNeeded()
         lynx_error("Install new apache")
      ;TODO wait for the finished page of the installer
   }
}

IsPerlUpgradeNeeded()
{
   if (GetPerlVersion() != "5.8.9")
      return true
   else
      return false
}

IsApacheUpgradeNeeded()
{
   if (GetApacheVersion() != "2.2.21")
      return true
   else
      return false
}

GetLatestLynxVersion()
{
   DownloadLynxFile("version.txt")
   returned := FileRead("C:\temp\lynx_upgrade_files\version.txt")
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
   ;dbFile=C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\lLynx.mdf
   ;dbFile=C:\Program Files\Microsoft SQL Server\MSSQL\MSSQL\DATA\lLynx.mdf
   dbSearchPath=C:\Program Files\Microsoft SQL Server\*
   Loop, %dbSearchPath%, 0, 1
   {
      if RegExMatch(A_LoopFileName, "Lynx\.mdf$")
         dbFile := A_LoopFileFullPath
   }
   dbSearchPath=C:\Program Files (x86)\Microsoft SQL Server\*
   Loop, %dbSearchPath%, 0, 1
   {
      if RegExMatch(A_LoopFileName, "Lynx\.mdf$")
         dbFile := A_LoopFileFullPath
   }

   if FileExist(dbFile)
   {
      dbSize:=FileGetSize(dbFile, "M")
      if (dbSize > 200)
      {
         msg=Inform level 2 support that the database file size is %size%MB
         msg(msg)
      }
   }
   else
   {
      importantLogInfo("Could not find database file")
      msg("Check database file size to ensure it is smaller than 200MB, if it is larger than 200MB, inform level 2 support")
      ;TODO please provide the full path to the MDF file
   }
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

DownloadAllLynxFilesForUpgrade()
{
   FileDeleteDirForceful("C:\temp\lynx_upgrade_files")

   notify("Downloading LynxGuide Upgrade Package")
   DownloadLynxFile("unzip.exe")
   DownloadLynxFile("upgrade_pack.zip")
   notify("Finished Downloading")

   FileCopyDir("C:\temp\lynx_upgrade_files\upgrade_scripts", "C:\inetpub\wwwroot\cgi", "overwrite")
}

