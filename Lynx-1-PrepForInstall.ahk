;Copy install files to the hard drive
FileCopyDir, \LynxCD\, C:\LynxCD\, 1

;Increase the screen resolution as much as possible
ForceWinFocus("Program Manager ahk_class Progman")
SleepSend("{AppsKey}c")

ForceWinFocus("Screen Resolution ahk_class CabinetWClass")
SleepSend("!r{UP 50}{ENTER}")
SleepSend("!a")

WinWaitActive, Display Settings, &Keep changes, 5
if NOT ERRORLEVEL
   SleepSend("!k")

ForceWinFocus("Screen Resolution ahk_class CabinetWClass")
SleepSend("!fc")
