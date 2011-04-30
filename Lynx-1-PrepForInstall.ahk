
;Copy install files to the hard drive
source:=DriveLetter() . ":\LynxCD\"
FileCopyDir, %source%, C:\LynxCD\, 1

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

;Increase the screen resolution as much as possible
ForceWinFocus("Program Manager ahk_class Progman")
SleepSend("{AppsKey}c")

;note that this is Run > "control desk.cpl"
ForceWinFocus("Screen Resolution ahk_class CabinetWClass")
SleepSend("!r{UP 50}{ENTER}")
SleepSend("!a")

WinWaitActive, Display Settings, &Keep changes, 5
if NOT ERRORLEVEL
   SleepSend("!k")

ForceWinFocus("Screen Resolution ahk_class CabinetWClass")
SleepSend("!fc")
