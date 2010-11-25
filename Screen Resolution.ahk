SetTitleMatchMode 3

Send, {LWINDOWN}{LWINUP}
WinWait, Start menu, 
IfWinNotActive, Start menu, , WinActivate, Start menu, 
WinWaitActive, Start menu, 
Send, screen{SPACE}resolution
Sleep, 100
Send, {ENTER}
Sleep, 100
WinWait, Screen Resolution, 
IfWinNotActive, Screen Resolution, , WinActivate, Screen Resolution, 
WinWaitActive, Screen Resolution, 
MouseClick, left,  500,  294
Sleep, 100

WinWait, Resolution Slider Pane, , 1
if ErrorLevel
{
	MouseClick, left,  400,  294
	WinWait, Resolution Slider Pane, 
	IfWinNotActive, Resolution Slider Pane, , WinActivate, Resolution Slider Pane, 
	WinWaitActive, Resolution Slider Pane, 
	MouseClick, left,  33,  45
}
else
{
	WinWait, Resolution Slider Pane, 
	IfWinNotActive, Resolution Slider Pane, , WinActivate, Resolution Slider Pane, 
	WinWaitActive, Resolution Slider Pane, 
	MouseClick, left,  33,  157
}

Sleep, 100
MouseClick, left,  265,  169
Sleep, 100
WinWait, Screen Resolution, 
IfWinNotActive, Screen Resolution, , WinActivate, Screen Resolution, 
WinWaitActive, Screen Resolution, 
MouseClick, left,  617,  472
Sleep, 100
WinWait, Display Settings, 
IfWinNotActive, Display Settings, , WinActivate, Display Settings, 
WinWaitActive, Display Settings, 
MouseClick, left,  200,  112
Sleep, 100