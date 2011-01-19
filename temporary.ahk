#include FcnLib.ahk

ForceWinFocus("Program Manager")
Send, {ALTDOWN}{ALTUP}
ForceWinFocus("2011-01-16-credit-graph.xls - OpenOffice.org Calc")
MouseClick, left,  120,  7
Sleep, 100
Send, {ALTDOWN}{ALTUP}ia
ForceWinFocus("Program Manager")

WinWait, Program Manager,
IfWinNotActive, Program Manager, , WinActivate, Program Manager,
WinWaitActive, Program Manager,
Send, {ALTDOWN}{ALTUP}
WinWait, 2011-01-16-credit-graph.xls - OpenOffice.org Calc,
IfWinNotActive, 2011-01-16-credit-graph.xls - OpenOffice.org Calc, , WinActivate, 2011-01-16-credit-graph.xls - OpenOffice.org Calc,
WinWaitActive, 2011-01-16-credit-graph.xls - OpenOffice.org Calc,
MouseClick, left,  120,  7
Sleep, 100
Send, {ALTDOWN}{ALTUP}ia
