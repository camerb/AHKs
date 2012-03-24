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

   services:="apache2.2,LynxApp1,LynxTCPService,LynxMessageServer,LynxMessageServer2,LynxMessageServer3"
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
   FileAppendLine(msg, GetPath("logfile")) ;log abbreviated message
   FileAppendLine(ret, GetPath("installall-logfile")) ;log full message to separate log

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
   StringLeft, returned, A_ScriptFullPath, 1
   return returned
}

ShortSleep()
{
   SleepSeconds(3)
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

   if (MaintType == "upgrade")
      MsgBox, , Lynx Upgrade Assistant, %message%
   else if (MaintType == "install")
      debug("", message)
   else
      MsgBox, , Lynx Technician Assistant, %message%
}

lynx_error(message)
{
   MaintType := GetLynxMaintenanceType()

   if (MaintType == "upgrade")
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

lynx_logAndShow(message)
{
   delog(message)
   lynx_message(message)
}

lynx_log(message)
{
   delog(message)
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
      lynx_log("Detected perl version: " . match1)
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
      lynx_log("Detected apache version: " . match1)
      if match1
         returned:=match1
      if RegExMatch(returned, "\d")
         break
      Sleep, 2000
   }
   lynx_log("Concluded that apache version is: " . match1)

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
   TestIfLynxIsThere()
   BannerDotPlx()
   CheckDb()
   GetIEVersion()
}

TestIfLynxIsThere()
{
   if NOT FileExist("C:\inetpub\wwwroot\cgi\checkdb.plx")
      lynx_error("It looks like this is not a valid lynx install (checkdb file is not there).")
}

TestCmdRet()
{
   output:=CmdRet_RunReturn("ping 127.0.0.1")
   RegExMatch(output, "Received \= (\d)", match)
   if (match1 == "4")
      lynx_log("passed TestCmdRet (using ping)")
   else
      lynx_log("ERROR: failed TestCmdRet (using ping)")

   pipedFile=C:\temp\out.txt
   FileCreate("", pipedFile)
   cmd=ping 127.0.0.1 > out.txt
   ;debug(cmd)
   CmdRet_RunReturn(cmd, "C:\temp\")
   if NOT FileExist(pipedFile)
      lynx_error("failed TestCmdRet (pipedFile didn't exist)")

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

LynxDatabaseQuery(query, columnsToLookAt="")
{
   params=get_query.plx "%query%" "%columnsToLookAt%"
   ret := CmdRet_Perl(params)
   return ret
}

GetSmsKey()
{
   queryResult:=LynxDatabaseQuery("select * from setup where [TYPE] = 'ID'", "Type,Value")
   RegExMatch(queryResult, "ID\t([A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12})\t", match)
   returned := match1
   delog("Attempted to get the SMS key and got this:", returned)
   return returned
}

DownloadLynxFile(filename)
{
   delog("", "starting download: " . filename)
   global connectionProtocol
   global downloadPath

   TestDownloadProtocol("ftp")
   TestDownloadProtocol("http")

   if NOT connectionProtocol
      lynx_error("Unable to download file. The server is unable to connect via ftp or http.")

   destinationFolder=C:\temp\lynx_upgrade_files
   url=%downloadPath%/%filename%
   dest=%destinationFolder%\%filename%

   if (filename == "7.12.zip")
      url := StringReplace(url, "/upgrade_files", "")

   FileCreateDir, %destinationFolder%
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

UnzipInstallPackage(file)
{
   ;7z=C:\temp\lynx_upgrade_files\7z.exe
   p=C:\temp\lynx_upgrade_files
   folder:=file
   ;cmd=%7z% a -t7z %p%\archive.7z %p%\*.txt
   cmd=%p%\unzip.exe %p%\%file%.zip -d %p%\%folder%
   CmdRet_RunReturn(cmd, p)
   ;notify("Working on " . file)
}

RunIfFileIsThere(program)
{
   if FileExist(program)
      Run, %program%
}
