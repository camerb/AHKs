#include FcnLib.ahk

`::
   WinWait, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc,
   IfWinNotActive, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc, , WinActivate, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc,
   WinWaitActive, 2010 Feb-Mar Account Balances.xls - OpenOffice.org Calc,
   MouseClick, left,  37,  7
   Sleep, 100
   Send, {CTRLDOWN}c{CTRLUP}
   date=%Clipboard%
   StringTrimLeft, date, date, 2
   StringTrimRight, date, date, 4
   date=02%date%2011
   ;debug(date)
   Send, %date%{UP}
return

