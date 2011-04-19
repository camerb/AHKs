ret := CmdRet_Runreturn("sc config AudioSrv start= auto")
if NOT InStr(ret, "SUCCESS")
   MsgBox, %ret%

Run, C:\LynxCD\Server 7.11\Text2Speech\SIIG\setup.exe
WinWaitActive, , Welcome to the InstallShield Wizard
SleepSend("!n")
SleepSend("!n")
WinWaitActive, , Installation is complete
SleepClick(35, 160)
SleepClick(160, 190)

Run, C:\LynxCD\Server 7.11\Text2Speech\kate\setup.exe
InstallTTS()
Run, C:\LynxCD\Server 7.11\Text2Speech\paul\setup.exe
InstallTTS()

Run, C:\LynxCD\Server 7.11\Text2Speech\setup.exe
SleepSeconds(2)
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
WinWaitActive, , Setup has finished installing
SleepSend("!f")
