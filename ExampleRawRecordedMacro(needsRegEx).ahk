WinWait, Troubles using memcpy - Google Chrome, 
IfWinNotActive, Troubles using memcpy - Google Chrome, , WinActivate, Troubles using memcpy - Google Chrome, 
WinWaitActive, Troubles using memcpy - Google Chrome, 
MouseClick, left,  645,  5
Sleep, 100
Send, {CTRLDOWN}{SHIFTDOWN}b{SHIFTUP}{CTRLUP}
WinWait, Bookmark Manager, 
IfWinNotActive, Bookmark Manager, , WinActivate, Bookmark Manager, 
WinWaitActive, Bookmark Manager, 
MouseClick, left,  89,  48
Sleep, 100
WinWait, Save As, 
IfWinNotActive, Save As, , WinActivate, Save As, 
WinWaitActive, Save As, 
Send, joe.html{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}
WinWait, Bookmark Manager, 
IfWinNotActive, Bookmark Manager, , WinActivate, Bookmark Manager, 
WinWaitActive, Bookmark Manager, 
MouseClick, left,  54,  16
Sleep, 100
Send, {ALTDOWN}{ALTUP}
MouseClick, left,  469,  4
Sleep, 100
MouseClick, left,  107,  13
Sleep, 100
MouseClick, left,  32,  15
Sleep, 100
MouseClick, left,  741,  10
Sleep, 100