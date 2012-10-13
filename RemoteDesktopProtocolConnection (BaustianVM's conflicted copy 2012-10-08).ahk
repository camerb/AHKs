#include FcnLib.ahk
#include FcnLib-Clipboard.ahk

computerName:=Prompt("Which computer do you want to connect to?")
computerName:=StringUpper(computerName)

;Lynx password is now default. Other servers will have to be hardcoded in
;different work computers have different passwords
;if RegExMatch(computerName, "i)^(T-1|T-101|T-800|KP|BURNIN|RELEASE|LYNXGUIDE|PRIMARYFO|SECONDARYFO)$")
if RegExMatch(computerName, "i)^(RUST|IRON|COPPER)$")
   joe:=SexPanther("work")
else
   joe:=SexPanther("lynx")

Clipboard := joe

RunProgram("C:\Windows\system32\mstsc.exe")
ForceWinFocus("Remote Desktop Connection", "Exact")
Sleep, 500

;expand the window if it isn't already expanded
WinGetActiveStats, no, winWidth, winHeight, no, no
Sleep, 1000
if (winHeight == 249)
   ClickButton("&Options")

;ClickButton("&Computer")
Sleep, 1000
Sleep, 1000
Sleep, 1000
Send, %computerName%
Sleep, 200
Send, {TAB}
Sleep, 200
Send, ^a
Sleep, 200
Send, %computerName%\administrator
ClickButton("Always &ask for credentials")
ClickButton("Co&nnect")

WinWaitActive, Windows Security
Sleep, 100
paste()
;TODO might want to use SendViaClipboard instead
;Send, %joe%
Sleep, 100
Send, {ENTER}

