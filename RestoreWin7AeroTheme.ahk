#include FcnLib.ahk
#include thirdParty/CmdRet.ahk

ProcessCloseAll("Aura.exe")

;CmdRet_RunReturn("control /name Microsoft.Personalization")
;Sleep, 500
;WinWaitActive, Personalization
;Sleep, 500
;Click(430, 230, "Mouse")
;Sleep, 500
;WinClose

Sleep, 2000
CmdRet_RunReturn("net stop uxsms")
CmdRet_RunReturn("net start uxsms")
Sleep, 10000
RunProgram("Aura")

;TODO perhaps I need to make some sort of a test to ensure that the color intensity is set strongly enough and is actually changing the color
