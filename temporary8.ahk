#include FcnLib.ahk

;Convert .doc to .pdf

ss()
Click(1174, 18, "left")
ss()
ForceWinFocus("OpenOffice.org Writer")
title:=WinGetActiveTitle()
RegExMatch(title, "^(.*).doc", match)
Click(178, 69, "left")
ss()
ForceWinFocus("Export")
Send, % match1
Click(509, 370, "left")
ss()
ForceWinFocus("OpenOffice.org Writer")
Send, {CTRLDOWN}ww{CTRLUP}

ESC::ExitApp
`::ExitApp

ss()
{
Sleep, 100
}
