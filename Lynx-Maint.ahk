;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpgradeParts.ahk
;#singleinstance force
Lynx_MaintenanceType := "maint"


;TODO make a gui instead

SendFileHome()

;the end of the maintenance
SleepMinutes(60*12)
Shutdown, 4
ExitApp


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
   lynx_log("Message displayed to technician...`n" . msg)
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
   if (GetPerlVersion() != "5.8.9")
      return true
   else
      return false
}

IsApacheUpgradeNeeded()
{
   if (GetApacheVersion() == "2.2.22")
      return false
   else if (GetApacheVersion() == "2.2.21")
      return false
   else
      return true
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

SendFileHome()
{
   delog("", "started function", A_ThisFunc)
   ;fix the params, if needed
   reasonForScript := GetLynxMaintenanceType()

   joe := GetLynxPassword("ftp")
   timestamp := CurrentTime("hyphenated")
   date := CurrentTime("hyphendate")
   logFileFullPath := GetPath("logfile")
   logFileFullPath2 := GetPath("checkdb-logfile")
   logFileFullPath3 := GetPath("installall-logfile")
   filePath := prompt("What file do you want to send?")
   description := prompt("Provide a description...")

   ;try to send it back using MS-ftp
   joe := GetLynxPassword("ftp")
   ftpFilename=ftp.txt

ftpfile=
(
open lynx.mitsi.com
AHK
%joe%
put %filepath% other/%description%.txt
quit
)

   FileCreate(ftpfile, ftpFilename)
   ret:=CmdRet_RunReturn("ftp -s:" . ftpFilename)
   ;notify("finished ftp connection")
   ;notify(ret)
   delog(ret)
   FileDelete(ftpFilename)
   debug("Finished File Transmission")

   ;send it back in an email
   subject=Finishing %reasonForScript% on %A_ComputerName%
   allLogs=%logFileFullPath%|%logFileFullPath2%|%logFileFullPath3%
   SendEmailNow(subject, A_ComputerName, allLogs, "cameron@mitsi.com")
   delog("", "finished function", A_ThisFunc)
}
