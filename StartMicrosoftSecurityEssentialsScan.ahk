#include FcnLib.ahk

RunProgram("msseces.exe")
ForceWinFocus("Microsoft Security Essentials")
SleepSeconds(2)
Send, !f
SleepSeconds(2)
Send, !s
