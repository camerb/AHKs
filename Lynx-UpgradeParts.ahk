#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-ProcedureParts.ahk

RunTaskManagerMinimized()
{
   delog("", "started function", A_ThisFunc)
   Run, taskmgr
   WinWait, Windows Task Manager
   WinMinimize
   delog("", "finished function", A_ThisFunc)
}

DownloadAllLynxFilesForUpgrade()
{
   delog("", "started function", A_ThisFunc)
   ;TODO if the modified date is older than today
   FileDeleteDirForceful("C:\temp\lynx_upgrade_files")

   notify("Downloading LynxGuide Upgrade Package")
   DownloadLynxFile("unzip.exe")
   ;DownloadLynxFile("7zip.zip")
   DownloadLynxFile("ActivePerl.zip")
   DownloadLynxFile("apache.zip")
   ;DownloadLynxFile("inetpub.zip")
   DownloadLynxFile("7.12.zip")
   DownloadLynxFile("upgrade_scripts.zip")
   ;DownloadLynxFile("zip-unzip.zip")
   notify("Finished Downloading")

   FileCopyDir("C:\temp\lynx_upgrade_files\upgrade_scripts\upgrade_scripts", "C:\inetpub\wwwroot\cgi", "overwrite")
   delog("", "finished function", A_ThisFunc)
}

CreateSmsKey()
{
   delog("", "started function", A_ThisFunc)
   if NOT GetSmsKey()
      msg("Ensure the SMS key is being created.")
   delog("", "finished function", A_ThisFunc)
}

InstallSmsKey()
{
   delog("", "started function", A_ThisFunc)
   if NOT GetSmsKey()
      msg("Install the new SMS key")
   delog("", "finished function", A_ThisFunc)
}

CheckDatabaseFileSize()
{
   delog("", "started function", A_ThisFunc)

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

   ;while NOT FileExist(dbFile)
   ;   prompt for the full path to the database file
   ; if they say it is a remote db, don't fret

   if FileExist(dbFile)
   {
      dbSize:=FileGetSize(dbFile, "M")
      delog("Checked the database size and found it was " . dbSize . "MB.")
      if (dbSize > 200)
      {
         msg=Inform level 2 support that the database file size is %size%MB
         msg(msg)
      }
   }
   else
   {
      lynx_log("Could not find database file")
      msg("Check database file size to ensure it is smaller than 200MB, if it is larger than 200MB, inform level 2 support")
      ;TODO please provide the full path to the MDF file
   }
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
   msg(msg)

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
   msg("Enter server RAM, Processor Speed and OS into Sugar")
   WinClose, System
   delog("", "finished function", A_ThisFunc)
}

TurnOffIisIfApplicable()
{
   delog("", "started function", A_ThisFunc)
   if NOT GetApacheVersion() ;Apache is not installed, must be IIS
      msg("Disable IIS: Turn off LynxGuide website, change port to 8081, turn off app pools")
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
      msg("Get the client data and put it into Sugar. The database query has been placed on the clipboard, so just paste it into SSMS to run it")
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
      lynx_log("I think this is an error: Not all services are stopped")
   delog("", "finished function", A_ThisFunc)
}

EnsureAllServicesAreRunning()
{
   delog("", "started function", A_ThisFunc)
   Sleep, 5000
   ;FIXME - make this an error, not a log
   if NOT AllServicesAre("running")
      lynx_log("I think this is an error: Not all services are running")
   PermanentEnableService("SMTPSVC")
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
      msg("Uninstall perl")
      while GetPerlVersion()
         lynx_error("Uninstall perl")

      oldPerlDir:="C:\Perl-old-" . CurrentTime("hyphenated")
      ;FileDeleteDirForceful("C:\Perl")
      FileMoveDir, "C:\Perl", oldPerlDir

      Run, C:\temp\lynx_upgrade_files\ActivePerl\ActivePerl\ActivePerl.msi
      lynx_log("Started perl installer")
      Sleep, 2000
      msg("Install new perl")
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
      msg("Uninstall apache")
      while GetApacheVersion()
         lynx_error("Uninstall apache")
      ;TODO wait for the finished page of the installer
      ;ensure the service is gone
      EnsureApacheServiceNotExist()

      Run, C:\temp\lynx_upgrade_files\7.12\tools\apache\apache.msi
      lynx_log("Started apache installer")
      Sleep, 2000
      msg("Install new apache")
      while IsApacheUpgradeNeeded()
         lynx_error("Install new apache")
      ;TODO wait for the finished page of the installer
   }
   CmdRet_RunReturn("net stop apache2.2")
   delog("", "finished function", A_ThisFunc)
}

CopyInetpubFolder()
{
   delog("", "started function", A_ThisFunc)
   notify("Copying the contents of the inetpub folder")

   ;NOTE that this is the zip file that we are downloading from the website!
   FileCopyDir("C:\temp\lynx_upgrade_files\7.12", "C:\Inetpub", "overwrite")
   AddSqlConnectStringFiles()
   notify("finished copying inetpub folder")
   delog("", "finished function", A_ThisFunc)
}

ShowUpgradeSummary()
{
   delog("", "started function", A_ThisFunc)
   global LynxOldVersion
   global LynxNewVersion
   msg=Upgraded server from %LynxOldVersion% to %LynxNewVersion%
   msg(msg)
   delog(msg)
   delog("", "finished function", A_ThisFunc)
}

BackupLynxDatabase(description)
{
   delog("", "started function", A_ThisFunc)

   archiveDescription=Archived%description%
   ArchiveDatabaseBackup(archiveDescription)
   Sleep, 1000

   ;TODO write the batch file (or copy it over)

   ;perform the backup
   path:="C:\inetpub\wwwroot\cgi\"
   batFile=%path%backupdb.bat
   if FileExist(batFile)
      RunWait, %batFile%, %path%
   else
      msg("Make the backup of the lynx database manually")

   Sleep, 1000

   ArchiveDatabaseBackup(archiveDescription)

   delog("", "finished function", A_ThisFunc)
}

