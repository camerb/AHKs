#include FcnLib.ahk

ExitApp

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
   WinWaitActive, , &Next
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
   SleepSeconds(1)
}

ESC::ExitApp
