#include FcnLib.ahk

WinWait, attribute_list-3.csv - OpenOffice.org Calc,
IfWinNotActive, attribute_list-3.csv - OpenOffice.org Calc, , WinActivate, attribute_list-3.csv - OpenOffice.org Calc,
WinWaitActive, attribute_list-3.csv - OpenOffice.org Calc,
MouseClick, left,  182,  314
Sleep, 100
Send, {CTRLDOWN}{END}{CTRLUP}{CTRLDOWN}{SHIFTDOWN}{HOME}{SHIFTUP}{CTRLUP}{CTRLDOWN}c{CTRLUP}

ForceWinFocus("RegEx File Processor (REFP)", "Exact")
MouseClick, left,  210,  110
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}
SendViaClipboard(Clipboard)
;{SHIFTDOWN}{SHIFTUP}{CTRLUP}{CTRLDOWN}v{CTRLUP}
MouseClick, left,  344,  518
Sleep, 100

Run, temporary1.ahk
