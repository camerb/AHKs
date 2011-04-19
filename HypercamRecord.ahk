#include FcnLib.ahk

fatalIfNotThisPC("BAUSTIAN-09PC")

RunProgram("C:\Program Files\HyCam2\HyCam2.exe")
ForceWinFocus("HyperCam")
SleepSeconds(5)
Send, {F2}

SleepMinutes(5)

Send, {F2}
SleepSeconds(5)
WinClose, HyperCam
SleepSeconds(5)
Process, Close, HyCam2.exe
