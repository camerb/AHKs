;install IIS (clickin' around)
GhettoCmdRet_RunReturn("%SystemRoot%\system32\ServerManager.msc", "", "extraGhettoForHighAuth")
ForceWinFocus("Server Manager")
SleepSeconds(20)
ForceWinFocus("Server Manager")
;TESTME verify that this block works correctly... seems like it ends up in the winwaitactive block below
SleepClick(20, 400)
SleepSend("{LEFT 10}")
SleepSend("{RIGHT}")
Loop 2
   SleepSend("{DOWN}")
SleepSend("{ENTER}")
SleepClick(845, 226)
SleepSend("{PGDN 50}")

SleepClick(253, 152)
;TESTME end of block to test

;WinWaitActive, , &Add Required Role Services
;WinWaitActive, , &Add Required Features
MultiWinWait("", "&Add Required Role Services", "", "&Add Required Features")
SleepSend("!a")
WinWaitActive, , SMTP Server supports the transfer of e-mail messages
SleepSend("!n")

WinWaitActive, , Introduction to Web Server (IIS), 10
if NOT ERRORLEVEL
   SleepSend("!n")

WinWaitActive, , Select the role services to install, 10
if NOT ERRORLEVEL
   SleepSend("!n")

;WinWaitActive, , &Install
WinWaitActive, , To install the following roles
SleepSend("!i")
WinWaitActive, , Installation succeeded
SleepSend("!o")

;stop and disable W3SVC service (WWW Pub Service)
ShortSleep()
CmdRet_RunReturn("net stop W3SVC")
ShortSleep()
ret := CmdRet_Runreturn("sc config W3SVC start= disabled")
if NOT InStr(ret, "SUCCESS")
   MsgBox, %ret%

WinClose, Server Manager

ForceWinFocus("(cmd.exe|Command Prompt)", "RegEx")
WinClose
