#include FcnLib.ahk

WinWait, attribute_list-3.csv - OpenOffice.org Calc, 
IfWinNotActive, attribute_list-3.csv - OpenOffice.org Calc, , WinActivate, attribute_list-3.csv - OpenOffice.org Calc, 
WinWaitActive, attribute_list-3.csv - OpenOffice.org Calc, 
MouseClick, left,  182,  314
Sleep, 100
Send, {CTRLDOWN}{END}{CTRLUP}{CTRLDOWN}{SHIFTDOWN}{HOME}{SHIFTUP}{CTRLUP}{CTRLDOWN}c{CTRLUP}
WinWait, , 
IfWinNotActive, , , WinActivate, , 
WinWaitActive, , 
MouseClick, left, -352,  224
Sleep, 100
WinWait, RegEx File Processor (REFP), 
IfWinNotActive, RegEx File Processor (REFP), , WinActivate, RegEx File Processor (REFP), 
WinWaitActive, RegEx File Processor (REFP), 
MouseClick, left,  210,  110
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}{SHIFTDOWN}{SHIFTUP}{CTRLUP}{CTRLDOWN}v{CTRLUP}
MouseClick, left,  344,  518
Sleep, 100