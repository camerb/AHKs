#include FcnLib.ahk
#include Lynx-FcnLib.ahk

BannerDotPlx()
{
   delog("", "started function", A_ThisFunc)
   ret := CmdRet_Perl("banner.plx")
   lynx_log("banner.plx returned: " . ret)
   if NOT InStr(ret, "Location: /banner") ;/banner.gif")
      lynx_error("the banner.plx file did not run correctly, instead it returned:" . ret)
   delog("", "finished function", A_ThisFunc)
}

CheckDb()
{
   delog("", "started function", A_ThisFunc)
   lockfile := "C:\inetpub\wwwroot\cgi\update.lck"

   ;do the checkdb
   ret := CmdRet_Perl("checkdb.plx")
   RestartService("apache2.2")
   len := strlen(ret)
   msg=Ran checkdb and the strlen of the checkdb was %len%

   if FileExist(lockfile)
   {
      lynx_error("Lockfile was present after a checkdb")
      ret .= "`n`nLOCKFILE WAS PRESENT AFTER THE CHECKDB"
      ;FileDelete(lockfile)
   }

   FileAppendLine(msg, GetPath("logfile")) ;log abbreviated message
   FileAppendLine(ret, GetPath("checkdb-logfile")) ;log full message to separate log

   delog("", "finished function", A_ThisFunc)
}

SendStartMaintenanceEmail()
{
   delog("", "started function", A_ThisFunc)
   maintType:=GetLynxMaintenanceType()
   subject=Starting an %maintType% on %A_ComputerName%
   SendEmailNow(subject, "", "", "cameron@mitsi.com")
   delog("", "finished function", A_ThisFunc)
}

StartLynxMaintenance()
{
   delog("", "started function", A_ThisFunc)
   SendStartMaintenanceEmail()
   WinClose, Initial Configuration Tasks
   delog("", "finished function", A_ThisFunc)
}

TestScriptAbilities()
{
   delog("", "started function", A_ThisFunc)
   lynx_log("ComputerName is: " . A_ComputerName)
   lynx_log("OS is: " . GetOS())
   TestCmdRet()
   TestIfLynxIsThere()
   TestStartStopService()
   ;TestCmdRetPerl()
   delog("", "finished function", A_ThisFunc)
}

SendLogsHome()
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

   ;try to send it back using MS-ftp
   joe := GetLynxPassword("ftp")
   ftpFilename=ftp.txt

ftpfile=
(
open lynx.mitsi.com
AHK
%joe%
put %logFileFullPath% %reasonForScript%_logs/%timestamp%.txt
put %logFileFullPath2% %reasonForScript%_logs/%timestamp%-checkdb.txt
put %logFileFullPath3% %reasonForScript%_logs/%timestamp%-installall.txt
quit
)

   FileCreate(ftpfile, ftpFilename)
   ret:=CmdRet_RunReturn("ftp -s:" . ftpFilename)
   ;notify("finished ftp connection")
   ;notify(ret)
   delog(ret)
   FileDelete(ftpFilename)

   ;send it back in an email
   subject=Finishing %reasonForScript% on %A_ComputerName%
   allLogs=%logFileFullPath%|%logFileFullPath2%|%logFileFullPath3%
   SendEmailNow(subject, A_ComputerName, allLogs, "cameron@mitsi.com")
   delog("", "finished function", A_ThisFunc)
}

