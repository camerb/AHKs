#include FcnLib.ahk
#include thirdParty/CmdRet.ahk

ProcessCloseAll("Aura.exe")
CmdRet_RunReturn("control /name Microsoft.Personalization")
Sleep, 500
WinWaitActive, Personalization
Sleep, 500
Click(430, 230, "Mouse")
Sleep, 500
WinClose

Sleep, 20000
RunProgram("Aura")

CmdRet_RunReturn("net start uxsms")
