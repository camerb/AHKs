#include FcnLib.ahk

`::
   ForceWinFocus("OpenOffice.org Calc")
   MouseClick, left,  37,  7
   Sleep, 100
   Send, {CTRLDOWN}c{CTRLUP}
   date=%Clipboard%
   StringTrimLeft, date, date, 2
   StringTrimRight, date, date, 4
   date=03%date%2011
   Send, %date%{UP}
return

