;set computer name
command=netdom.exe renamecomputer %A_ComputerName% /newname:%LynxCompyName%
;/userd:LAN\administrator /passwordd:Password1! /usero:administrator /passwordo:Password1! /reboot:2
GhettoCmdRet_RunReturn(command)
SleepSend("Y{ENTER}")
SleepSeconds(2)
WinClose

;turn off firewall
Run, C:\windows\system32\firewall.cpl
SleepClick(95, 175)
SleepClick(284, 247)
SleepClick(284, 382)
SleepClick(570, 570)
SleepSeconds(1)
WinClose, Windows Firewall
