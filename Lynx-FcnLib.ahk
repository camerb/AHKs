#include FcnLib.ahk
#include thirdParty/Notify.ahk
#include SendEmailSimpleLib.ahk
#include gitExempt/Lynx-Passwords.ahk

;this is a lib

ConfigureODBC(version)
{
   if (version == "32")
      Run, C:\Windows\system32\
   else if (version == "64")
      Run, C:\Windows\SysWOW64\

   SleepSeconds(2)
   SleepSend("odbcad32{ENTER}")

   ForceWinFocus("ODBC Data Source Administrator")
   SleepClick(106,  41)
   SleepClick(401,  94)
   ForceWinFocus("Create New Data Source")
   SleepSend("{DOWN 50}")
   SleepSend("{UP}")
   SleepClick(330,  319)
   ForceWinFocus("Create a New Data Source to SQL Server")
   SleepSend("!m")
   SleepSend("LynxSQL")
   SleepSend("!d")
   SleepSend("Lynx")
   SleepSend("!s")
   SleepSend("(local)")
   SleepSend("!n")
   WinWaitActive, , verify the authenticity, 10
   SleepSend("!n")
   WinWaitActive, , default database, 10
   SleepSend("!d")
   SleepSend("{TAB}")
   SleepSend("Lynx")
   SleepSend("!n")
   WinWaitActive, , Change the language, 10
   ;if (version == "32")
      ;SleepClick(292, 363)
   ;else if (version == "64")
   SleepClick(292, 327)
   WinWaitActive, , &Test Data Source, 10
   SleepSend("!t")
   SetTitleMatchMode, Slow
   WinWaitActive, , TESTS COMPLETED SUCCESSFULLY
   SetTitleMatchMode, Fast
   SleepClick(179, 353)

   WinWaitActive, , &Test Data Source, 10
   SleepClick(258, 353)
   ForceWinFocus("ODBC Data Source Administrator")
   SleepClick(170, 353)
   SleepSeconds(1)
}

SleepSend(text)
{
   ShortSleep()
   Sleep, 3000
   Send, %text%
}

SleepClick(xCoord, yCoord, options="Left Mouse")
{
   ShortSleep()
   Sleep, 3000
   Click(xCoord, yCoord, options)
}

PermanentEnableService(serviceName)
{
   cmd1=net start %serviceName%
   cmd2=sc config %serviceName% start= auto
   CmdRet_RunReturn(cmd1)
   ret := CmdRet_Runreturn(cmd2)

   ;TODO figure out what to do here... do we want to log it?
   ;if NOT InStr(ret, "SUCCESS")
      ;MsgBox, %ret%
}

PermanentDisableService(serviceName)
{
   cmd1=net stop %serviceName%
   cmd2=sc config %serviceName% start= disabled
   CmdRet_RunReturn(cmd1)
   ret := CmdRet_Runreturn(cmd2)

   ;TODO figure out what to do here... do we want to log it?
   ;if NOT InStr(ret, "SUCCESS")
      ;MsgBox, %ret%
}

RestartService(serviceName)
{
   ;NOTE I could use the sc command, but that wouldn't wait for the service to start successfully
   ;the NET command is basically a RunWait for services
   Sleep, 100
   CmdRet_RunReturn("net stop " . serviceName)
   Sleep, 100
   CmdRet_RunReturn("net start " . serviceName)
   Sleep, 100
}

QueryAllRelatedServices()
{
   services:="apache2.2,LynxMessageServer,LynxMessageServer2,LynxMessageServer3,LynxTCPService,LynxApp1,LynxWebServer,LynxWebServer1,LynxClientManager,W3SVC,msSQLserver,SQLbrowser,SQLwriter,SQLagent"
   Loop, parse, services, CSV
   {
      serviceName:=A_LoopField
      ret := CmdRet_RunReturn("sc query " . serviceName)
      lynx_log("sc query: " . serviceName . "   " . ret)
      ;lynx_log("sc query: " . serviceName)
      ;lynx_log("sc query returned: " . ret)
   }
}

AllServicesAre(status)
{
   ;FIXME - seems like this has issues in returning the incorrect value (maybe stopped includes some that aren't installed?
   ;usage: stopped or running or started
   if InStr(status, "STOPPED")
      status=(STOPPED|FAILED)
   else if InStr(status, "STARTED") OR InStr(status, "RUNNING")
      status=RUNNING
   else
      fatalErrord("", "USAGE: AllServicesAre(status) where status can be started, stopped or running")

   services:="apache2.2,LynxMessageServer,LynxMessageServer2,LynxMessageServer3,LynxTCPService,LynxClientManager"
   Loop, parse, services, CSV
   {
      serviceName:=A_LoopField
      ret := CmdRet_RunReturn("sc query " . serviceName)
      lynx_log("sc query: " . serviceName . "   " . ret)
      Sleep, 100
      if NOT RegExMatch(ret, status)
      {
         lynx_error("Service had an incorrect status: " . serviceName . "   " . ret)
         return false
      }
   }
   return true
}

RemoveAll()
{
   ret := CmdRet_Perl("start-MSG-service.pl removeall")
   len := strlen(ret)
   msg=Removed all services and the strlen of the removeall was %len%
   FileAppendLine(msg, GetPath("logfile")) ;log abbreviated message
   FileAppendLine(ret, GetPath("removeall-logfile")) ;log full message to separate log
}

InstallAll()
{
   ret := CmdRet_Perl("start-MSG-service.pl installall")
   len := strlen(ret)
   msg=Installed all services and the strlen of the installall was %len%
   FileAppendLine(msg, GetPath("lynx-logfile")) ;log abbreviated message
   FileAppendLine(ret, GetPath("lynx-installall")) ;log full message to separate log

   if NOT ret
      errord("installall", "(error 1) known issues here: this command returned nothing", ret)
   if InStr(ret, "Cannot start")
      errord("installall", "Couldn't start a service... it returned:", ret)
   if InStr(ret, "***")
      errord("installall", "this command seemed to have an error... it returned:", ret)
   if NOT InStr(ret, "Finished with 0 errors")
      errord("installall", "this command seemed to fail... it returned:", ret)
}

ConfigureW3SVCservice()
{
   ;stop and disable W3SVC service (WWW Pub Service)
   ;SleepSeconds(20)
   ShortSleep()
   CmdRet_RunReturn("net stop W3SVC")
   ShortSleep()
   ret := CmdRet_Runreturn("sc config W3SVC start= disabled")
   ;DO NOT check for success... (it may not have been installed in the first place)
   ;if NOT InStr(ret, "SUCCESS")
      ;MsgBox, %ret%
}

ConfigureAudioSrvService()
{
   ;SleepSeconds(20)
   ret := CmdRet_Runreturn("sc config AudioSrv start= auto")
   if NOT InStr(ret, "SUCCESS")
      MsgBox, %ret%
   ShortSleep()
   CmdRet_RunReturn("net start AudioSrv")
   ShortSleep()
}

GhettoCmdRet_RunReturn(command, workingDir="", options="")
{
   if InStr(options, "extraGhettoForHighAuth")
   {
      SleepSend("{LWIN}")
      SleepSend("Command Prompt")
      SleepSend("{ENTER}")
   }
   else
      Run, cmd.exe

   ForceWinFocus("(cmd.exe|Command Prompt)", "RegEx")

   if workingDir
   {
      SleepSend("cd " . workingDir)
      SleepSend("{ENTER}")
   }

   SleepSend(command)
   SleepSend("{ENTER}")

   ;TODO should we make something that will close the cmd window at the end?
}

autologin(options)
{
   drive := DriveLetter()
   path="%drive%:\LynxCD\Server 7.11\installAssist\autologon.exe"
   if InStr(options, "enable")
   {
      Run, %path% /accepteula
      ForceWinFocus("Autologon")
      SleepSend("{TAB}")
      SleepSend("Administrator")
      SleepSend("{TAB}")
      SleepSend(A_IPaddress1)
      SleepSend("{TAB}")
      SleepSend("Password1!")
      SleepSend("{TAB}")
      SleepSend("{ENTER}")
      SleepSend("{ENTER}")

   }
   else if InStr(options, "disable")
   {
      Run, %path% /accepteula
      ForceWinFocus("Autologon")
      Loop 5
         SleepSend("{TAB}")
      SleepSend("{ENTER}")
      SleepSend("{ENTER}")
   }
   else
   {
      debug("did you misspell the options for autologin?")
   }
}

InstallTTS()
{
   ;WinWaitActive, , &Next
   SleepSeconds(10)
   SleepSend("!n")
   WinWaitActive, , &Yes
   SleepSend("!y")
   WinWaitActive, , &Next
   SleepSend("!n")
   WinWaitActive, , InstallShield Wizard Complete
   SleepClick(360, 350)
}

DriveLetter()
{
   ;StringLeft, returned, A_ScriptFullPath, 1
   if FileExist("E:\Lynx-InstallBootstrap.exe")
      returned=E
   else
      lynx_error("Drive letter of the flash drive is not E")
   return returned
}

ShortSleep()
{
   ;SleepSeconds(1)
   SleepSeconds(3)
   ;changed to 1 second on 2012-04-20
   ;restored to 3 second on 2012-04-24 (seemed like SQL auth page couldn't get the entire password)
}

WinLogActiveStats(function, lineNumber)
{
   WinGetActiveStats, winTitle, width, height, xPosition, yPosition
   WinGetText, winText, A
   allVars=function,lineNumber,winTitle,width,height,xPosition,yPosition,winText
   Loop, Parse, allVars, CSV
      %A_LoopField% := A_LoopField . ": " . %A_LoopField%
   delog("Debugging window info", function, lineNumber, winTitle, width, height, xPosition, yPosition, winText)
}

;for batch files and stuff
CmdRet_Lynx(command)
{
   ;this specifies the full path twice, but it seems to make it more reliable for some reason
   path:="C:\inetpub\wwwroot\cgi\"
   fullCommand=%path%%command%
   returned := CmdRet_RunReturn(fullCommand, path)
   return returned
}

;I'd rather integrate this in with CmdRet_Lynx in the long term
CmdRet_Perl(command)
{
   ;this specifies the full path twice, but it seems to make it more reliable for some reason
   path:="C:\inetpub\wwwroot\cgi\"
   fullCommand=perl %path%%command%
   returned := CmdRet_RunReturn(fullCommand, path)
   return returned
}

ArchiveDatabaseBackup(description="ArchivedDuringUpdate")
{
   if InStr(description, "ArchivedBeforeUpdate")
      description=ArchivedBeforeUpdate
   else if InStr(description, "ArchivedAfterUpdate")
      description=ArchivedAfterUpdate
   else
      description=ArchivedDuringUpdate

   backupFile=C:\inetpub\backup\lynx.bak
   if FileExist(backupFile)
   {
      fileTime := FileGetTime(backupFile)
      fileTime := FormatTime(fileTime, "hyphenated")
      archiveFile=C:\inetpub\backup\DatabaseArchive\%fileTime%-LynxDatabase-%description%.bak
      FileMove(backupFile, archiveFile, "overwrite")
   }
}

lynx_message(message)
{
   MaintType := GetLynxMaintenanceType()
   ;debug(mainttype)

   if (MaintType = "update")
   {
      ;debug(A_ComputerName)
      ;if (A_ComputerName = "T-800")
         ;return

      message .= "`n`nLynx Maintenance has been paused. Click OK once you have performed the action specified above."
      lynx_log("Message displayed to technician...`n" . message)
      MsgBox, , Lynx Upgrade Assistant, %message%
   }
   else if (MaintType == "install")
      debug("", message)
   else
      MsgBox, , Lynx Technician Assistant, %message%
}

lynx_error(message)
{
   MaintType := GetLynxMaintenanceType()

   if (MaintType == "update")
   {
      full_message := "ERROR (Inform Level 2 support): " . message
      lynx_message(full_message)
      lynx_log(full_message)
   }
   else if (MaintType == "install")
   {
      errord("", message)
   }
   else
   {
      full_message := "ERROR (Inform Level 2 support): " . message
      lynx_message(full_message)
      lynx_log(full_message)
   }
}

lynx_fatalerror(message)
{
   lynx_error("FATAL " . message)
   ExitApp
}

lynx_log(message)
{
   FileAppend("`n`n" . message, GetPath("lynx-generic"))
}

;get rid of this... all messages should be logged!
lynx_logAndShow(message)
{
   lynx_deprecated(A_ThisFunc)
   lynx_log(message)
   lynx_message(message)
}

;TODO figure out how this should be different from the normal logs...
; should the filename look like 2011-11-28-important.txt ???
lynx_importantlog(message)
{
   delog(message)
}

GetLynxVersion()
{
   clientInfo := CmdRet_Perl("client_info.plx")
   RegExMatch(clientInfo, "LynxMessageServer3\t([0-9.]+)", match)
   if match1
   {
      lynxVersion := match1
      lynx_log("Detected lynx version (from database): " . lynxVersion)
   }

   ;TODO might want to check both the DB and the version file
   versionFile=C:\inetpub\version.txt
   if FileExist(versionFile)
      FileRead, returned, %versionFile%
   RegExMatch(returned, "v([0-9.]+)", match)
   if match1
   {
      lynxVersion := match1
      lynx_log("Detected lynx version (from version text file): " . lynxVersion)
   }

   if NOT lynxVersion
      lynxVersion := "unknown"
   lynx_log("Detected lynx version: " . lynxVersion)

   return lynxVersion
}

GetPerlVersion()
{
   Loop, 20
   {
      output:=CmdRet_RunReturn("perl -v")
      RegExMatch(output, "v([0-9.]+)", match)
      ;lynx_log("Detected perl version: " . match1)
      if match1
         returned:=match1
      if RegExMatch(returned, "\d")
         break
      Sleep, 2000
   }
   lynx_log("Concluded that perl version is: " . match1)

   ;Check to see if there is a chance that we are getting conflicting info from the perl installation
   perlIsInstalled := !! match1
   perlDirIsThere := !! FileDirExist("C:\Perl")
   errorMsg:="SILENT Checked to see if C:\Perl exists, and also checked 'perl -v' and got conflicting info"
   if (perlIsInstalled AND !perlDirIsThere)
      lynx_log(errorMsg)
   if (!perlIsInstalled AND perlDirIsThere)
      lynx_log(errorMsg)

   return returned
}

GetApacheVersion()
{
   if FileDirExist("C:\Program Files (x86)\Apache Software Foundation\Apache2.2")
      installDirIsThere := true
   if FileDirExist("C:\Program Files\Apache Software Foundation\Apache2.2")
      installDirIsThere := true
   if NOT installDirIsThere
   {
      lynx_log("I think this is an error: Apache install directory cannot be found")
      return ""
   }

   file=C:\Program Files\Apache Software Foundation\Apache2.2\bin\httpd.exe
   if FileExist(file)
      ApacheExePath := file
   file=C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin\httpd.exe
   if FileExist(file)
      ApacheExePath := file
   ;ApacheExePath := ProgramFilesDir("\Apache Software Foundation\Apache2.2\bin\httpd.exe")
   Loop, 20
   {
      output := CmdRet_RunReturn(ApacheExePath . " -v")
      RegExMatch(output, "Apache.([0-9.]+)", match)
      ;lynx_log("Detected apache version: " . match1)
      if match1
         returned:=match1
      if RegExMatch(returned, "\d")
         break
      Sleep, 2000
   }
   lynx_log("Concluded that apache version is: " . match1)

   return returned
}

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
   else
      returned := true

   delog(A_ThisFunc, "Determined if the update was needed (next line)", returned, version)
   return returned
}

;Send an email without doing any of the complex queuing stuff
SendEmailNow(sSubject, sBody, sAttach="", sTo="cameronbaustian@gmail.com", sReplyTo="cameronbaustian+bot@gmail.com")
{
   ;sUsername, sPassword,

   ;item .= SexPanther()

   sFrom     := username . "@gmail.com"

   sServer   := "smtp.gmail.com" ; specify your SMTP server
   nPort     := 465 ; 25
   bTLS      := True ; False
   nSend     := 2   ; cdoSendUsingPort
   nAuth     := 1   ; cdoBasic
   sUsername := "cameronbaustianmitsibot"
   sPassword := GetLynxPassword("email")

   ;FIXME... make me a separate script!
   ;SendTheFrigginEmail(sSubject, sAttach, sTo, sReplyTo, sBody, sUsername, sPassword, sFrom, sServer, nPort, bTLS, nSend, nAuth)
}

GetLynxMaintenanceType()
{
   global Lynx_MaintenanceType
   ;fix the params, if needed
   Lynx_MaintenanceType := StringReplace(Lynx_MaintenanceType, "upgrade", "update")
   if NOT Lynx_MaintenanceType
      Lynx_MaintenanceType := "UNSPECIFIED"
   return Lynx_MaintenanceType
}

TestLynxSystem()
{
   ;EnsureAllServicesAreRunning() ;DO NOT DO THIS BEFORE AN UPDATE, services may change from one version to the next
   TestIfLynxIsThere()
   BannerDotPlx()
   GetIEVersion()
   ;CheckDb() ;NEVER EVER DO THIS, it takes a long time and may delete client info

   ;a little hack: hit the webpage for the 256, to get it to reboot itself when locked up
   if (A_ComputerName = "release")
      UrlDownloadToVar("http://10.6.1.91/")
}

TestIfLynxIsThere()
{
   if ( GetLynxMaintenanceType() == "install" )
      return

   if NOT FileExist("C:\inetpub\wwwroot\cgi\checkdb.plx")
      lynx_error("It looks like this is not a valid lynx install (checkdb file is not there).")
}

TestCmdRet()
{
   output:=CmdRet_RunReturn("ping 127.0.0.1")
   RegExMatch(output, "Received \= (\d)", match)
   lynx_log("Result of TestCmdRet using ping command was: " . match1)
   if (match1 > "1")
      lynx_log("passed TestCmdRet (using ping)")
   else
      lynx_log("ERROR: failed TestCmdRet (using ping)")

   ;NOTE this will NEVER work due to the nature of the command
   ;pipedFile=C:\temp\out.txt
   ;FileCreate("", pipedFile)
   ;cmd=ping 127.0.0.1 > out.txt
   ;;debug(cmd)
   ;CmdRet_RunReturn(cmd, "C:\temp\")
   ;if NOT FileExist(pipedFile)
      ;lynx_error("failed TestCmdRet (pipedFile didn't exist)")

   ;this doesn't really work
   ;output:=FileRead(pipedFile)
   ;FileDelete(pipedFile)
   ;RegExMatch(output, "Received \= (\d)", match)
   ;if (match1 == "4")
      ;lynx_log("passed TestCmdRet (using pipedFile)")
   ;else
      ;lynx_error("failed TestCmdRet (using pipedFile - incorrect contents of file)")
   ;errord("notimeout", output)

   GetPerlVersion()
}

TestStartStopService()
{
   if ( GetLynxMaintenanceType() == "install" )
      return

   ret := CmdRet_RunReturn("sc stop LynxMessageServer3")
   lynx_log(ret)
   if ( InStr(ret, "FAILED") AND InStr(ret, "Access is denied") )
   {
      lynx_error("Unable to start and stop a service. Administrative rights are required for Lynx Maintenance, you probably need more privileges.")
      return
   }
   Sleep, 10000
   CmdRet_RunReturn("sc start LynxMessageServer3")
}

GetIEVersion()
{
   RegRead, IEVersion, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Internet Explorer, Version
   lynx_log("IE (Internet Explorer) Version is: " . IEVersion)
   return IEVersion
}

ShowTrayMessage(message)
{
   quote="
   message := EnsureStartsWith(message, quote)
   message := EnsureEndsWith(message, quote)
   RunAhk("Lynx-NotifyBox.ahk", message)
}

HideTrayMessage(message)
{
   ;get pid (maybe get all pids)
   ;ProcessClose(pid)
}

;TODO Run function with logging
;On second thought, this seems like a really bad idea
;RunFunctionWithLogging(functionName)
;{
   ;if NOT IsFunc(functionName)
      ;return

   ;delog("", "started function", functionName)
   ;%A
   ;delog("", "finished function", functionName)
   ;FIXME the real issue here is that if the functions return early, the function will say that it finished, even though it didn't actually get to the end of it
;}

CleanupServerSupervision()
{
   ;check the count of services checkins
   ServicesCount := LynxDatabaseQuery("SELECT COUNT(*) as count FROM IPaddress WHERE [ID] = 'LynxGuide'", "count")
   lynx_log("Count of LynxGuide checkins 1 " . ServicesCount)

   allServices := "LynxTCPservice,LynxMessageServer%,%AOLservice%,%RSS service%,LynxClientManager,LynxWebServer%,LynxApp%"
   Loop, parse, allServices, CSV
   {
      if NOT A_LoopField
         continue
      LynxDatabaseQuery("DELETE FROM IPaddress WHERE [type] = '" . A_LoopField . "'")
   }

   ;check the count of services checkins
   ;this should be zero
   ServicesCount := LynxDatabaseQuery("SELECT COUNT(*) as count FROM IPaddress WHERE [ID] = 'LynxGuide'", "count")
   lynx_log("Count of LynxGuide checkins 2 " . ServicesCount)

   LynxDatabaseQuery("DELETE FROM IPaddress WHERE [ID] = 'LynxGuide'")

   ;check the count of services checkins
   ;this should be zero
   ServicesCount := LynxDatabaseQuery("SELECT COUNT(*) as count FROM IPaddress WHERE [ID] = 'LynxGuide'", "count")
   lynx_log("Count of LynxGuide checkins 3 " . ServicesCount)
}

LynxDatabaseQuery(query, columnsToLookAt="")
{
   params=get_query.plx "%query%" "%columnsToLookAt%"

   LynxFileCreate("GetQuery")
   returned := CmdRet_Perl(params)
   LynxFileDelete("GetQuery")

   return returned
}

LynxDatabaseQuerySingleItem(query, columnsToLookAt="")
{
   returned := LynxDatabaseQuery(query, columnsToLookAt)
   returned := RegExReplace(returned, "`t`n$")
   return returned
}

LynxFileCreate(nickname)
{
   if (nickname = "GetQuery")
      text := "use strict;`nno warnings;`nrequire ""utilities.plx"";`nour $Data = &LynxSetup;`n`nmy $GroupSel;`nmy $ChannelSel;`nmy @sql1Params;`n`nmy $sql1 = shift;`nmy @columns = split(',', shift);`n`nif ($Data->Prepare($sql1)) 	{	&Print_ODBC_Error($Data,__FILE__,__LINE__);	}`nif ($Data->Execute(@sql1Params)) 	{ 	&Print_ODBC_Error($Data,__FILE__,__LINE__);	}`n`nour $counter = 0;`nwhile ($Data->FetchRow())`n{`n   my %Data = $Data->DataHash();`n`n   foreach my $column (@columns)`n   {`n      print $Data{$column};`n      print ""\t"";`n   }`n   print ""\n"";`n}"
   if (nickname = "BackupDb")
      text := "@echo off`ncd \Inetpub\wwwroot\cgi`nsqlcmd -S .\ -i dobackup.sql >> ""c:\Inetpub\log\backuplog.txt"""

   FileCreate(text, LynxFileGetPath(nickname))
}

LynxFileDelete(nickname)
{
   FileDelete(LynxFileGetPath(nickname))
}

LynxFileGetPath(nickname)
{
   if (nickname = "GetQuery")
      returned=C:\inetpub\wwwroot\cgi\get_query.plx
   return returned
}

;TESTME
GetCompanyName()
{
   CompanyName := LynxDatabaseQuerySingleItem("Select [value] from setup where [type] = 'CompanyName'", "value")
   lynx_log("CompanyName was |||" . CompanyName . "|||")
   return CompanyName
}

GetBackupPath()
{
   returned := LynxDatabaseQuerySingleItem("select * from Setup where type = 'BackupDIR'", "Value")
   ;if InStr(returned, "wwwroot")
      ;lynx_error("The log file location is in wwwroot, this needs to be fixed. The recommended log location is C:/inetpub/log")
   lynx_log("Backup Dir Path was |||" . returned . "|||")
   return returned
}

GetLogPath()
{
   returned := LynxDatabaseQuerySingleItem("select * from Setup where type = 'log'", "Value")
   if InStr(returned, "wwwroot")
      lynx_error("The log file location is in wwwroot, this needs to be fixed. The recommended log location is C:/inetpub/log")
   lynx_log("Logging Path was |||" . returned . "|||")
   return returned
}

GetDatabaseFilePath()
{
   returned := LynxDatabaseQuerySingleItem("select a.name, b.name as 'Logical filename', b.filename from sys.sysdatabases a inner join sys.sysaltfiles b on a.dbid = b.dbid where fileid = 1 and a.name = 'Lynx'", "filename")
   lynx_log("DB File Path was |||" . returned . "|||")
   return returned
}

GetSmsKey()
{
   queryResult:=LynxDatabaseQuery("select * from setup where [TYPE] = 'ID'", "Type,Value")
   RegExMatch(queryResult, "ID\t([A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12})\t", match)
   returned := match1
   lynx_log("Attempted to get the SMS key and got this |||" . returned . "|||")
   return returned
}

GetLynxPath(pathName)
{
   ;if
}

DownloadLynxFile(filename)
{
   global connectionProtocol
   global downloadPath
   destinationFolder=C:\temp\lynx_update_files

   delog("", "starting download: " . filename)

   ;delog("", "creating directory for downloading into")
   FileCreateDir, %destinationFolder%

   if NOT FileDirExist(destinationFolder)
      lynx_error("The directory for downloading to did not exist after it was downloaded.`nThis probably means it does not have permissions to access the directory.`n" . destinationFolder)

   ;(changed on 2012-05-09) used to test ftp first until it had would "hang" on the montco secondary server (never had issues on the primary)  ;(changed on 2012-05-23) - also had issues on VA Las Vegas server
   ;TestDownloadProtocol("ftp")
   TestDownloadProtocol("http")
   TestDownloadProtocol("ftp")
   delog("", "Connection protocol is: ", connectionProtocol)

   if NOT connectionProtocol
      lynx_error("Unable to download file. The server is unable to connect via ftp or http.")

   url=%downloadPath%/%filename%
   dest=%destinationFolder%\%filename%

   ;These files are in the base path, so they can be accessed easily by the techs
   if RegExMatch(filename, "(7.12.zip|Lynx-Install.exe|Lynx-Maint.exe)")
      url := StringReplace(url, "/upgrade_files", "")

   ;TODO if the modified date is older than today
   ;delog("", "Deleting old files")
   FileDelete(dest)

   ;delog("", "starting the download")
   UrlDownloadToFile, %url%, %dest%

   if NOT FileExist(dest)
      lynx_error("The file did not exist after it was downloaded.`nThis probably means it does not have permissions to access the directory.`n" . dest)

   ;TODO perhaps we want to unzip the file now (if it is a 7z)
   if RegExMatch(filename, "^(.*)\.zip$", match)
      UnzipInstallPackage(match1)
}

TestDownloadProtocol(testProtocol)
{
   global connectionProtocol
   global downloadPath

   delog("", "Testing Download Protocol: " . testProtocol)
   ;debug("hello1")

   if connectionProtocol
      return ;we already found a protocol, so don't run the test again
   ;debug("hello2")

   ;prepare for the test
   pass:=GetLynxPassword("generic")
   ;debug("hello3")
   if (testProtocol == "ftp")
      downloadPath=ftp://update:%pass%@lynx.mitsi.com/upgrade_files
   else if (testProtocol == "http")
      downloadPath=http://update:%pass%@lynx.mitsi.com/Private/techsupport/upgrade_files
   ;debug("hello4")

   ;test it
   url=%downloadPath%/test.txt

   ;debug("hello5")
   ;UrlDownloadToFile, %url%, C:\temp\lynx_update_files\test.txt
   ;debug("hello6")
   ;joe := FileRead(file)
   ;debug("hello7")

   joe:=UrlDownloadToVar(url)
   ;debug("hello8")

   ;determine if the test was successful
   if (joe == "test message")
      connectionProtocol:=testProtocol

   delog("", "Connection protocol is: ", connectionProtocol)
}

UnzipInstallPackage(file)
{
   ;7z=C:\temp\lynx_update_files\7z.exe
   p=C:\temp\lynx_update_files
   folder:=file
   ;cmd=%7z% a -t7z %p%\archive.7z %p%\*.txt
   file := EnsureEndsWith(file, ".zip")
   cmd=%p%\unzip.exe %p%\%file% -d %p%\%folder%
   CmdRet_RunReturn(cmd, p)
   ;notify("Working on " . file)
}

OpenLogFile()
{
   logfile:=GetPath("logfile")
   Run, notepad.exe %logfile%
}

RunIfFileIsThere(program)
{
   if FileExist(program)
      Run, %program%
}

PreMaintenanceTasks()
{
   ;get information
   lynx_log("User: " . A_UserName)
   lynx_log("Hostname / Computer Name: " . A_ComputerName)
   lynx_log("OS: " . A_OSType)
   lynx_log("SQL version: " . GetSQLversion())

   lynx_log( CmdRet_RunReturn("set") )
   lynx_log( CmdRet_RunReturn("wmic os get totalvisiblememorysize") )
   lynx_log( CmdRet_RunReturn("wmic os get freephysicalmemory") )

   ;do things
   EnsureDirExists("C:\inetpub\Backup\DatabaseArchive")
   ;FileDeleteDirForceful("C:\inetpub\wwwroot\TrueUpdate")
   ;FileDeleteDirForceful("C:\inetpub\wwwroot\_TrueUpdate")

   ;these things have built-in checks
   GetLogPath()
}

PostMaintenanceTasks()
{
   ;Better defaults in the setup table
   LynxDatabaseQuery("UPDATE [Setup] SET [Value] = 5 WHERE [type] = 'LoginRejectedSleepTime' AND [value] = 60")

   ;it can't hurt to leave this in... stopped saving things to dropbox folder 2011-11-15
   if FileDirExist("C:\Dropbox")
      errord("SILENT", "ERROR: Weird. The Dropbox folder is there.")
   ;if NOT IsMyCompy()
      ;FileRemoveDir, C:\Dropbox, 1
}

TryToFindLynxDbPath(dbSearchPath)
{
   ;dbSearchPath=C:\Program Files (x86)\Microsoft SQL Server\*
   Loop, %dbSearchPath%, 0, 1
   {
      if RegExMatch(A_LoopFileName, "Lynx\.mdf$")
         dbFile := A_LoopFileFullPath
   }
   return dbFile
}

SetServiceToRetryAfterFailures(serviceName)
{
   cmd=SC failure %serviceName% reset= 86400  actions= restart/30000/restart/60000/restart/90000
   CmdRet_RunReturn(cmd)
}

GetSqlVersion()
{
   returned := LynxDatabaseQuery("Select @@version as version", "version")
   lynx_log("SQL version was " . returned)
   return returned
}

CheckIfSubscriptionNeedsToBeTurnedOff()
{
   homePage := LynxDatabaseQuery("select * from setup where [type] = 'Home'", "Value")

   if (homePage == "no_subscription.htm")
      return
   else
      lynx_message("Ask the customer if they have a public subscription page`n`nIf not: Under Home Page and Subscriber Setup, change the home page to no_subscription.htm")
}

lynx_deprecated(FunctionName)
{
   msg=REMOVEME - the %FunctionName%() function is deprecated
   lynx_log(msg)
}

LongWinWait(winText)
{
   ;100 minute timeout... freakishly long
   WinWaitActive, , %winText%, 1200
   ;WinWaitActive, , %winText%, 6000
   if ERRORLEVEL
      fatalErrord("", "A dialog during the Lynx install process never appeared", wintext)
   SleepSeconds(5)
}

DeleteExcessUpdaterFiles()
{
   fileList=client_info.plx,get_query.plx,dbattach.sql,dbattach.bat
   ;fileList=client_info.plx,get_query.plx,backupdb.bat,dbattach.sql,dbattach.bat
   Loop, parse, fileList, CSV
   {
      thisFile := A_LoopField
      thisPath=C:\inetpub\wwwroot\cgi\%thisFile%
      FileDelete(thisPath)
   }
}
