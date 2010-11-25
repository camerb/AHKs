Send, {LWINDOWN}{LWINUP}
WinWait, Start Menu, 
IfWinNotActive, Start Menu, , WinActivate, Start Menu, 
WinWaitActive, Start Menu, 
Send, personalization
Sleep, 100
Send {ENTER}
WinWait, Personalization, 
IfWinNotActive, Personalization, , WinActivate, Personalization, 
WinWaitActive, Personalization, 
MouseClick, left,  299,  506
Sleep, 100
WinWait, Display Settings, 
IfWinNotActive, Display Settings, , WinActivate, Display Settings, 
WinWaitActive, Display Settings, 
MouseClick, left,  360,  171
Sleep, 100
MouseClick, left,  62,  302
Sleep, 100
MouseClick, left,  275,  459
Sleep, 2200
MouseClick, left,  235,  114
Sleep, 100
WinWait, Personalization, 
IfWinNotActive, Personalization, , WinActivate, Personalization, 
WinWaitActive, Personalization, 
MouseClick, left,  773,  1
WinClose, Personalization, 