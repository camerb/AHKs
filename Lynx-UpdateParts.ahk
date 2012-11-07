#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-ProcedureParts.ahk


ShowPreliminaryUpdateSummary()
{
   global LynxOldVersion
   global LynxDestinationVersion
   global PerlUpgradeNeeded
   global ApacheUpgradeNeeded

   LynxOldVersion := GetLynxVersion()
   LynxDestinationVersion := GetLatestLynxVersion()
   PerlUpgradeNeeded:=IsPerlUpgradeNeeded()
   ApacheUpgradeNeeded:=IsApacheUpgradeNeeded()

   if (LynxOldVersion != LynxDestinationVersion)
      lynx_message("Attempting an update from Lynx Version: " . LynxOldVersion . " to " . LynxDestinationVersion)
   else
      lynx_log("ERROR: It appears this server is already on the current version: " . LynxOldVersion . " to " . LynxDestinationVersion)
}

RunTaskManagerMinimized()
{
   delog("", "started function", A_ThisFunc)
   Run, taskmgr
   WinWaitActive, Windows Task Manager, , 5
   ;if ERRORLEVEL
      ;delog(Get
   WinMinimize, Windows Task Manager
   delog("", "finished function", A_ThisFunc)
}

DownloadAllLynxFilesForUpgrade()
{
   delog("", "started function", A_ThisFunc)

   ;I was thinking we might want to skip this download part, but really, we should download it again in case corruption is a suspect
   FileDeleteDirForceful("C:\temp\lynx_update_files")
   FileDeleteDirForceful("C:\temp\lynx_upgrade_files")
   FileRemoveDir, C:\temp\lynx_update_files\, 1
   FileRemoveDir, C:\temp\lynx_update_files, 1

   notify("Downloading LynxGuide Update Package")
   DownloadLynxFile("unzip.exe")
   DownloadLynxFile("ensure-current.txt")
   test := CurrentTime("hyphendate")
   text := FileRead("C:\temp\lynx_update_files\ensure-current.txt")

   ;if file not found
   if not (text == test)
   {
      lynx_log("silent ERROR: File download was unsuccessful, check to ensure that files can be downloaded from lynx.mitsi.com")
      ;lynx_error("File download was unsuccessful, check to ensure that files can be downloaded from lynx.mitsi.com")
      ;ExitApp
   }
   DownloadLynxFile("Lynx-Maint.exe")
   DownloadLynxFile("ActivePerl.zip")
   DownloadLynxFile("apache.zip")
   DownloadLynxFile("upgrade_scripts.zip")
   DownloadLynxFile("DefaultDatabase.zip") ;take this out later, just wanted to ensure that the file download path was correct during installs
   DownloadLynxFile("7.12.zip")

   ;TODO enable this for in-house testing
   rcFile := "C:\temp\rc.zip"
   if FileExist(rcFile)
   {
      delog("Using internal release candidate file instead of the public release")
      FileDeleteDirForceful("C:\temp\lynx_update_files\7.12")
      FileDelete("C:\temp\lynx_update_files\7.12.zip")
      FileCopy(rcFile, "C:\temp\lynx_update_files\7.12.zip")
      UnzipInstallPackage("7.12")
   }

   notify("Finished Downloading")

   FileCopyDir("C:\temp\lynx_update_files\upgrade_scripts\upgrade_scripts", "C:\inetpub\wwwroot\cgi", "overwrite")
   delog("", "finished function", A_ThisFunc)
}

CreateSmsKey()
{
   delog("", "started function", A_ThisFunc)
   if NOT GetSmsKey()
      lynx_message("Ensure the SMS key is being created.")
   delog("", "finished function", A_ThisFunc)
}

InstallSmsKey()
{
   delog("", "started function", A_ThisFunc)
   if NOT GetSmsKey()
      lynx_message("Install the new SMS key")
   delog("", "finished function", A_ThisFunc)
}

CheckDatabaseFileSize()
{
   delog("", "started function", A_ThisFunc)

   if NOT FileExist(dbFile)
      dbFile := GetDatabaseFilePath()

   if NOT FileExist(dbFile)
      lynx_log("RARE: Could not get Database File Path using a query")

   if NOT FileExist(dbFile)
   {
      dbSearchPath=C:\Program Files\Microsoft SQL Server\*
      Loop, %dbSearchPath%, 0, 1
      {
         if RegExMatch(A_LoopFileName, "Lynx\.mdf$")
            dbFile := A_LoopFileFullPath
      }
   }

   if NOT FileExist(dbFile)
   {
      dbSearchPath=C:\Program Files (x86)\Microsoft SQL Server\*
      Loop, %dbSearchPath%, 0, 1
      {
         if RegExMatch(A_LoopFileName, "Lynx\.mdf$")
            dbFile := A_LoopFileFullPath
      }
   }

   ;TODO
   ;Guess path of DB file
   ;Get folder of DB file
   ;Get exact path of MDF

   ;while NOT FileExist(dbFile)
   ;   prompt for the full path to the database file
   ; if they say it is a remote db, don't fret
   while NOT FileExist(dbFile)
   {
      dbFile := Prompt("Please provide the full path for the database MDF")
      if (dbFile = "remote")
         break
   }

   if FileExist(dbFile)
      dbSize:=FileGetSize(dbFile, "M")

   if (dbFile = "remote")
   {
      lynx_log("Database is a remote database")
      dbSize := 1
   }

   if FileExist(dbFile)
   {
      msg=Database file size is %dbSize% MB
      if (dbSize > 200)
         lynx_error(msg)
      else
         lynx_message(msg)
   }

   if NOT dbSize
   {
      lynx_log("ERROR: Could not find database file (this should not happen)")
      lynx_message("Check database file size to ensure it is smaller than 200MB, if it is larger than 200MB, inform level 2 support")
      ;TODO please provide the full path to the MDF file
   }

   if FileExist(dbFile)
      lynx_log("DB file path provided did exist")
   else
      lynx_log("ERROR: DB file path provided did NOT exist")

   lynx_log("Database file path is: " . dbFile)
   lynx_log("Database file size is: " . dbSize)

   delog("", "finished function", A_ThisFunc)
}

GetServerSpecs()
{
   delog("", "started function", A_ThisFunc)
   Loop 4
   {
      thisIP := A_IPaddress%A_Index%
      if (thisIP != "0.0.0.0")
         IPlist .= "`n" . thisIP
   }
   msg=The server's computer name is %A_ComputerName%`nThe server's IP addresses are: %IPlist%`n`nPlease enter this info into Sugar
   lynx_message(msg)

   Run, control /name Microsoft.System
   ;RunIfFileIsThere(A_WinDir . "\system32\msinfo32.exe")
   ;RunIfFileIsThere("C:\Program Files\Common Files\Microsoft Shared\MSInfo\msinfo32.exe")
   ;Run, %A_WinDir%\system32\msinfo32.exe
   ;Run, "C:\Program Files\Common Files\Microsoft Shared\MSInfo\msinfo32.exe"
   ;TODO doesn't work on Server 2003
   ;Start > Programs > Accessories > System Tools > System Information

   notify("Launching system panel (you may have to launch this manually from Start > Settings > Control Panel > System)")
   WinWait, System, , 20
   Sleep, 1000
   ;UNCOMMENTME SaveScreenShot("serverSpecs", "C:\inetpub\logs\lynxUpgrades\", "activeWindow")
   lynx_message("Enter server RAM and OS into Sugar")
   WinClose, System

   CompanyName := GetCompanyName()
   ;delog("CompanyName was", CompanyName)
   ;lynx_message("CompanyName was " . CompanyName)

   delog("", "finished function", A_ThisFunc)
}

TurnOffIisIfApplicable()
{
   delog("", "started function", A_ThisFunc)
   if NOT GetApacheVersion() ;Apache is not installed, must be IIS
      lynx_message("Disable IIS: Turn off LynxGuide website, change port to 8081, turn off app pools")
   delog("", "finished function", A_ThisFunc)
}

GetClientInfo()
{
   delog("", "started function", A_ThisFunc)
   ;TODO need to filecreate the perl code to client_info.plx

   ret := CmdRet_Perl("client_info.plx")
   ret := StringReplace(ret, "`t", "  `t  ")
   if InStr(ret, "LynxMessageServer") ;TODO perhaps check if a tab is in there... that would be more generic
      lynx_logAndShow("Enter client data from Lynx Database into Sugar`n`n" . ret)
   else
   {
      Clipboard=SELECT [type],[ver],count(*) FROM[ipaddress] GROUP BY [type],[ver]
      lynx_message("Get the client data and put it into Sugar. The database query has been placed on the clipboard, so just paste it into SSMS to run it")
      lynx_log("I think this is an error: Tried to get client data from the database, but got this instead: " . ret)
   }
   delog("", "finished function", A_ThisFunc)
}

EnsureAllServicesAreStopped()
{
   delog("", "started function", A_ThisFunc)
   Sleep, 5000
   ;FIXME - make this an error, not a log
   if NOT AllServicesAre("stopped")
      lynx_log("ERROR: Not all services are stopped")
   delog("", "finished function", A_ThisFunc)
}

EnsureAllServicesAreRunning()
{
   delog("", "started function", A_ThisFunc)
   Sleep, 20000
   ;FIXME - make this an error, not a log
   if NOT AllServicesAre("running")
      lynx_log("ERROR: Not all services are running")
   PermanentEnableService("SMTPSVC")
   PermanentEnableService("AUDIOSRV")
   PermanentDisableService("W3SVC")
   delog("", "finished function", A_ThisFunc)
}

StopAllLynxServices()
{
   delog("", "started function", A_ThisFunc)
   RemoveAll()
   CmdRet_RunReturn("net stop apache2.2")
   TCP:="LynxTCPService.exe"

   Loop, 10
      ProcessClose(TCP)

   Sleep, 500
   if ProcessExist(TCP)
      lynx_error("LynxTCP service didn't seem to close")
   delog("", "finished function", A_ThisFunc)
}

UpgradePerlIfNeeded()
{
   delog("", "started function", A_ThisFunc)
   if IsPerlUpgradeNeeded()
   {
      lynx_message("Uninstall perl")
      while GetPerlVersion()
         lynx_error("Uninstall perl")

      oldPerlDir:="C:\Perl-old-" . CurrentTime("hyphenated")
      ;FileDeleteDirForceful("C:\Perl")
      FileMoveDir, "C:\Perl", oldPerlDir

      Run, C:\temp\lynx_update_files\ActivePerl\ActivePerl\ActivePerl.msi
      lynx_log("Started perl installer")
      Sleep, 2000
      lynx_message("Install new perl")
      while IsPerlUpgradeNeeded()
         lynx_error("Install new perl")

      FileDeleteDirForceful(oldPerlDir)
   }
   delog("", "finished function", A_ThisFunc)
}

UpgradeApacheIfNeeded()
{
   delog("", "started function", A_ThisFunc)
   if IsApacheUpgradeNeeded()
   {
      lynx_message("Uninstall apache")
      while GetApacheVersion()
         lynx_error("Uninstall apache")
      ;TODO wait for the finished page of the installer
      ;ensure the service is gone
      EnsureApacheServiceNotExist()

      Run, C:\temp\lynx_update_files\7.12\tools\apache\apache.msi
      lynx_log("Started apache installer")
      Sleep, 2000
      lynx_message("Install new apache")
      while IsApacheUpgradeNeeded()
      {
         lynx_error("Install new apache")
         CmdRet_RunReturn("sc stop apache2.2")
      }
      CmdRet_RunReturn("sc stop apache2.2")
      ;TODO wait for the finished page of the installer
   }
   CmdRet_RunReturn("net stop apache2.2")
   delog("", "finished function", A_ThisFunc)
}

DeleteOldPerlLibDir()
{
   oldLibDir := "C:\inetpub\wwwroot\cgi\My\Params"
   FileDeleteDirForceful(oldLibDir)
   FileRemoveDir, %oldLibDir%, 1
}

CopyInetpubFolder()
{
   delog("", "started function", A_ThisFunc)
   notify("Copying the contents of the inetpub folder")

   ;NOTE that this is the zip file that we are downloading from the website!
   FileCopyDir("C:\temp\lynx_update_files\7.12", "C:\Inetpub", "overwrite")
   AddSqlConnectStringFiles()

   ;verify that the files were copied correctly
   if NOT IsFileEqual("C:\temp\lynx_update_files\7.12\version.txt", "C:\inetpub\version.txt")
      lynx_error("version.txt did not copy correctly")
   if NOT IsFileEqual("C:\temp\lynx_update_files\7.12\wwwroot\cgi\checkdb.plx", "C:\inetpub\wwwroot\cgi\checkdb.plx")
      lynx_error("checkdb.plx did not copy correctly")

   notify("finished copying inetpub folder")
   delog("", "finished function", A_ThisFunc)
}

ShowUpgradeSummary()
{
   delog("", "started function", A_ThisFunc)
   global LynxOldVersion
   global LynxNewVersion
   msg=Upgraded server from %LynxOldVersion% to %LynxNewVersion%
   lynx_message(msg)
   delog(msg)
   delog("", "finished function", A_ThisFunc)
}

BackupLynxDatabase(description)
{
   delog("", "started function", A_ThisFunc)

   archiveDescription=Archived%description%
   ArchiveDatabaseBackup(archiveDescription)
   Sleep, 1000

   LynxFileCreate("BackupDb")

   ;perform the backup
   path:="C:\inetpub\wwwroot\cgi\"
   batFile=%path%backupdb.bat
   if FileExist(batFile)
      RunWait, %batFile%, %path%
   else
   {
      lynx_message("Make the backup of the lynx database manually")
      lynx_log("ERROR: BackupDb File was not present")
   }

   Sleep, 1000

   ArchiveDatabaseBackup(archiveDescription)

   delog("", "finished function", A_ThisFunc)
}

;FIXME this doesn't work well yet, seems to grab wrong CompanyName
RenameLynxguideAlarmChannels()
{
allTitles=
(
001|on|Server Service Message
002|on|Server Login
006|on|File System Backup
007|on|Database Backup
008|on|Log File
009|on|Server Low Disk Space
000|on|Server Supervision Lost
000|no|Server Supervision Restored
)

   CompanyName := GetCompanyName()
   Loop, parse, allTitles, `n
   {
      StringSplit, column, A_LoopField, |
      sqlQuery=UPDATE alarms SET subject = '%CompanyName% %column3%' WHERE site = 'LynxGuide' AND alarm = '%column1%' AND alarmState = '%column2%'
      LynxDatabaseQuery(sqlQuery)
   }
}
