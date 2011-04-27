;set computer name
command=netdom.exe renamecomputer %A_ComputerName% /newname:%LynxCompyName%
GhettoCmdRet_RunReturn(command)
SleepSend("Y{ENTER}")
SleepSeconds(2)
WinClose

;turn off firewall
Run, C:\windows\system32\firewall.cpl
ForceWinFocus("Windows Firewall")
SleepClick(95, 175)
ForceWinFocus("Customize Settings")
SleepClick(284, 247)
SleepClick(284, 382)
SleepClick(570, 570)
SleepSeconds(1)
WinClose, Windows Firewall
