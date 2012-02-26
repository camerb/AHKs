#include FcnLib.ahk
#include FcnLib-Clipboard.ahk

computerName:=Prompt("Which computer do you want to connect to?")
computerName:=StringUpper(computerName)

;different work computers have different passwords
if RegExMatch(computerName, "i)^(T-1|T-101|T-800|KP|BURNIN|RELEASE|LYNXGUIDE|PRIMARYFO|SECONDARYFO)$")
   joe:=SexPanther("lynx")
else
   joe:=SexPanther("work")
Clipboard := joe

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
paste()
;TODO might want to use SendViaClipboard instead
;Send, %joe%
Sleep, 100
Send, {ENTER}

