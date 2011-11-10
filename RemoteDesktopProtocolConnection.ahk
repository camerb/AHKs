#include FcnLib.ahk

computerName:=Prompt("Which computer do you want to connect to?")
computerName:=StringUpper(computerName)

;different work computers have different passwords
if RegExMatch(computerName, "i)^(T-1|T-101|T-800)$")
   joe:=SexPanther("lynx")
else
   joe:=SexPanther("work")

RunProgram("C:\Windows\system32\mstsc.exe")
ForceWinFocus("Remote Desktop Connection", "Exact")

;expand the window if it isn't already expanded
WinGetActiveStats, no, winWidth, winHeight, no, no
if (winHeight == 249)
   ClickButton("&Options")

;ClickButton("&Computer")
Sleep, 1000
Send, %computerName%
ClickButton("Always &ask for credentials")
ClickButton("Co&nnect")

WinWaitActive, Windows Security
Sleep, 100
Send, %joe%
Sleep, 100
Send, {ENTER}

