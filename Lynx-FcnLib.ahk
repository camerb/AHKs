#include FcnLib.ahk
#include SendEmailSimpleLib.ahk
#include gitExempt/Lynx-Passwords.ahk

ExitApp ;this is a lib

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
   Send, %text%
}

SleepClick(xCoord, yCoord, options="Left Mouse")
{
   ShortSleep()
   Click(xCoord, yCoord, options)
}

#include thirdparty/cmdret.ahk
RestartService(serviceName)
{
   ShortSleep()
   CmdRet_RunReturn("net stop " . serviceName)
   ShortSleep()
   CmdRet_RunReturn("net start " . serviceName)
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
   ;SleepSend("Y{ENTER}")
   ;SleepSeconds(2)
   ;WinClose
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

   SendTheFrigginEmail(sSubject, sAttach, sTo, sReplyTo, sBody, sUsername, sPassword, sFrom, sServer, nPort, bTLS, nSend, nAuth)
}

SendLogsHome(reasonForScript="UNSPECIFIED")
{
   ;fix the params, if needed
   reasonForScript := StringReplace(reasonForScript, "upgrade", "update")

   joe := GetLynxPassword("ftp")
   timestamp := Currenttime("hyphenated")
   date := Currenttime("hyphendate")
   logFileFullPath := GetPath("logfile")

   ;send it back via ftp
   dest=ftp://lynx.mitsi.com/%reasonForScript%_logs/%timestamp%.txt
   cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%logFileFullPath%" --user AHK:%joe% %dest%
   ret:=CmdRet_RunReturn(cmd)

   ;send it back in an email
   subject=%reasonForScript% Logs
   SendEmailNow(subject, A_ComputerName, logFileFullPath, "cameron@mitsi.com")
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
;RunFunctionWithLogging(functionName)
;{
   ;if NOT IsFunc(functionName)
      ;return

   ;delog("", "started function", functionName)
   ;%A
   ;delog("", "finished function", functionName)
   ;FIXME the real issue here is that if the functions return early, the function will say that it finished, even though it didn't actually get to the end of it
;}

