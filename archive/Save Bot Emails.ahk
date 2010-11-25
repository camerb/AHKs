Run, "C:\Program Files\Mozilla Thunderbird\thunderbird.exe"
WinWait, Inbox - Thunderbird, 
IfWinNotActive, Inbox - Thunderbird, , WinActivate, Inbox - Thunderbird, 
WinWaitActive, Inbox - Thunderbird, 

WinMaximize, Inbox - Thunderbird, 
Sleep, 5000

while (true)
{
	MouseClick, left,  323,  142
	Sleep, 100
	MouseClick, left,  386,  21
	Sleep, 100
	Send, {CTRLDOWN}s{CTRLUP}
	WinWait, Save Message As, , 10
	if ErrorLevel
	{
		WinClose, Inbox - Thunderbird, 
		Exit
	}
	IfWinNotActive, Save Message As, , WinActivate, Save Message As, 
	WinWaitActive, Save Message As, 
	MouseClick, left,  462,  337
	Sleep, 100

	Send {HOME}C:\DataExchange\BotEmails\
	FormatTime FileNameText,, yyyyMMddHHmmss
	SendInput %FileNameText%
	SendInput -
	Random, FileNameText, 100000000, 999999999
	SendInput %FileNameText%
	SendInput -

	MouseClick, left,  365,  407
	Sleep, 100
	MouseClick, left,  469,  406
	Sleep, 100
	WinWait, Inbox - Thunderbird, 
	IfWinNotActive, Inbox - Thunderbird, , WinActivate, Inbox - Thunderbird, 
	WinWaitActive, Inbox - Thunderbird, 
	MouseClick, left,  313,  139
	Sleep, 100
	MouseClick, left,  464,  79
	Sleep, 100
}