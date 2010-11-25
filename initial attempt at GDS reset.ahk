{SHIFTUP}{CTRLUP}
WinWait, , 
IfWinNotActive, , , WinActivate, , 
WinWaitActive, , 
MouseClick, right,  1177,  155
Sleep, 100
MouseClick, left,  28,  8
Sleep, 100
MouseClick, right,  121,  237
Sleep, 100
MouseClick, left, -37,  252
Sleep, 100
MouseClick, right,  105,  346
Sleep, 100
MouseClick, left,  25,  7
Sleep, 100
WinWait, Save As, 
IfWinNotActive, Save As, , WinActivate, Save As, 
WinWaitActive, Save As, 
Send, backup]0d{BACKSPACE}{BACKSPACE}{BACKSPACE}[od{BACKSPACE}{BACKSPACE}{BACKSPACE}]0d{BACKSPACE}{BACKSPACE}{BACKSPACE}[0d{BACKSPACE}{BACKSPACE}{BACKSPACE}
WinWait, , 
IfWinNotActive, , , WinActivate, , 
WinWaitActive, , 
MouseClick, left,  29,  11
Sleep, 100
WinWait, Save As, 
IfWinNotActive, Save As, , WinActivate, Save As, 
WinWaitActive, Save As, 
Send, backuptodo
WinWait, , 
IfWinNotActive, , , WinActivate, , 
WinWaitActive, , 
Send, {PGUP}{PGDN}{PGUP}