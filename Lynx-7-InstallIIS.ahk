;install IIS (clickin' around)
GhettoCmdRet_RunReturn("%SystemRoot%\system32\ServerManager.msc", "", "extraGhettoForHighAuth")
ForceWinFocus("Server Manager")
SleepClick(80, 400)
SleepSend("{LEFT 10}")
SleepSend("{RIGHT}")
Loop 2
   SleepSend("{DOWN}")
SleepSend("{ENTER}")
SleepClick(845, 226)
SleepSend("{PGDN 50}")

SleepClick(253, 152)
WinWaitActive, , &Add Required Features
SleepSend("!a")
WinWaitActive, , SMTP Server supports the transfer of e-mail messages
SleepSend("!n")
WinWaitActive, , &Install
SleepSend("!i")
WinWaitActive, , Installation succeeded
SleepSend("!o")

WinClose, Server Manager

ForceWinFocus("(cmd.exe|Command Prompt)", "RegEx")
WinClose
