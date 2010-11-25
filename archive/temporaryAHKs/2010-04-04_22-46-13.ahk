WinWait, , 
IfWinNotActive, , , WinActivate, , 
WinWaitActive, , 
MouseClick, left,  337,  995
Sleep, 100
WinWait, AHK Filename, 
IfWinNotActive, AHK Filename, , WinActivate, AHK Filename, 
WinWaitActive, AHK Filename, 
Send, {CTRLDOWN}v{CTRLUP}{ENTER}