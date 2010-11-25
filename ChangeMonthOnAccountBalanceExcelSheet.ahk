#include FunctionLibrary.ahk

WinWait, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc,
IfWinNotActive, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc, , WinActivate, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc,
WinWaitActive, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc,
MouseClick, left,  37,  7
Sleep, 100
Send, {CTRLDOWN}c{CTRLUP}
date=%Clipboard%
StringTrimLeft, date, date, 2
date=12%date%
Send, %date%{UP}

