;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpdateParts.ahk
;#singleinstance force
Lynx_MaintenanceType := "maint"


;TODO make a gui instead
;Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
;Gui, Color, 000032
Gui, Add, Button, , Send File To Mitsi
Gui, Add, Button, , Cleanup Server Supervision
Gui, Add, Button, , Time Since Last Reboot
;Gui, Add, Button, , Turn Off Output Alarms
;get status of all lynx related services
Gui, Add, Button, , Debug Test
Gui, Show, , Lynx Maintenance Panel

;the end of the maintenance
;TODO put this in a separate file and just run it with no tray icon
SleepMinutes(60*12)
Shutdown, 4
ExitApp

ButtonSendFileToMitsi:
SendFileHome()
return
ButtonCleanupServerSupervision:
CleanupServerSupervision()
msg("Finished Server Supervision Cleanup")
return
ButtonTimeSinceLastReboot:
TimeSinceLastReboot()
return
ButtonTurnOffOutputAlarms:
TurnOffOutputAlarms()
return
ButtonDebugTest:
DebugTest()
return

;ghetto hotkey
;Appskey & r::
;SetTitleMatchMode, 2
;WinActivate, Notepad
;WinWaitActive, Notepad
;Sleep, 200
;Send, {ALT}fs
;Sleep, 200
;reload
;return


msg(message)
{
   lynx_deprecated(A_ThisFunc)
   message .= "`n`nLynx Maintenance has been paused. Click OK once you have performed the action specified above."
   lynx_log("Message displayed to technician...`n" . msg)
   MsgBox, , Lynx Upgrade Assistant, %message%
}

LynxError(message)
{
   lynx_deprecated(A_ThisFunc)
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

   reasonForScript := GetLynxMaintenanceType()
   joe := GetLynxPassword("ftp")
   timestamp := CurrentTime("hyphenated")
   date := CurrentTime("hyphendate")

   filePath := Prompt("What file do you want to send?`n`nProvide the full path")
   if NOT FileExist(filePath)
   {
      msg("File specified does not exist. Please provide the full path.")
      return
   }
   RegExMatch(filePath, ".{3}$", fileExtension)

   description := Prompt("Provide a description...")
   description := RegExReplace(description, "[^A-Za-z0-9]", "-")

   ;try to send it back using MS-ftp
   joe := GetLynxPassword("ftp")
   ftpFilename=ftp.txt

ftpfile=
(
open lynx.mitsi.com
AHK
%joe%
put "%filepath%" "other/%description%.%fileExtension%"
quit
)

   FileCreate(ftpfile, ftpFilename)
   ret:=CmdRet_RunReturn("ftp -s:" . ftpFilename)
   ;debug(ret)
   delog(ret)
   FileDelete(ftpFilename)

   ;TODO ensure that the file got to the ftp site (use a GET)

   msg("Finished File Transmission... please check the FTP site to ensure it is there")

   delog("", "finished function", A_ThisFunc)
}

TimeSinceLastReboot()
{
   debug("Time Since Last Reboot", A_TickCount, convert(A_TickCount))
}

TurnOffOutputAlarms()
{
   CmdRet_RunReturn("sc stop LynxMessageServer")
   CmdRet_RunReturn("sc stop LynxMessageServer2")
   CmdRet_RunReturn("sc stop LynxMessageServer3")
   CmdRet_RunReturn("sc stop LynxTCPservice")
   CmdRet_RunReturn("sc stop LynxClientManager")
   Sleep, 5000
   PermanentDisableService("LynxMessageServer")
   PermanentDisableService("LynxMessageServer2")
   PermanentDisableService("LynxMessageServer3")
   PermanentDisableService("LynxTCPservice")
   PermanentDisableService("LynxClientManager")
}

DebugTest()
{
   GetSqlVersion()
   RenameLynxguideAlarmChannels()
   ;CheckDatabaseFileSize()

   ;SqlVersion := LynxDatabaseQuery("Select @@version as version", "version")
   ;CompanyName := GetCompanyName()
   ;;delog("CompanyName was", CompanyName)
   ;msg("SQL version was " . SQLversion)
   ;msg("CompanyName was " . CompanyName)
}
