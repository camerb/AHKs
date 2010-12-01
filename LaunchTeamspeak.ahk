#include FcnLib.ahk

Run, "C:\Program Files\TeamSpeak 3 Client\ts3client_win32.exe"

ForceWinFocus("TeamSpeak 3")
Send, {CTRLDOWN}s{CTRLUP}

ForceWinFocus("Connect")
Send, {ENTER}

ForceWinFocus("TeamSpeak 3")
WaitForImageSearch("images\teamspeak\ConnectedToServer.bmp")
MouseClick, left,  40,  115
Sleep, 500
;WaitFor my name to disappear (or for the top area to turn into a plus sign)
MouseClick, right,  67,  133
;Sleep, 100
WaitForImageSearch("images\teamspeak\ReadyToSwitchChannels.bmp")
Send, {DOWN}{ENTER}

