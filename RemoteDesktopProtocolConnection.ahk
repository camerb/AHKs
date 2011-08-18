#include FcnLib.ahk

computerName:="copper"
joe:=SexPanther("work")
computerName:=Prompt("Which computer do you want to connect to?")

RunProgram("C:\Windows\system32\mstsc.exe")
ForceWinFocus("Remote Desktop Connection", "Exact")
WinGetActiveStats, no, winWidth, winHeight, no, no

if (winHeight == 249)
   ClickButton("&Options")

;ClickButton("&Computer")
Sleep, 1000
Send, %computerName%
ClickButton("Always &ask for credentials")
ClickButton("Co&nnect")

WinWaitActive, Windows Security
Send, %joe%{ENTER}

