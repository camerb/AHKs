;set computer name
command=netdom.exe renamecomputer %A_ComputerName% /newname:%LynxCompyName%
GhettoCmdRet_RunReturn(command)
SleepSend("Y{ENTER}")
SleepSeconds(2)
WinClose

