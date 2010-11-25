;Set up TeamSpeak
Run C:\Program Files\Teamspeak2_RC2\TeamSpeak.exe
WinWait, TeamSpeak 2, 
IfWinNotActive, TeamSpeak 2, , WinActivate, TeamSpeak 2, 
WinWaitActive, TeamSpeak 2, 
Send, {ALTDOWN}{ALTUP}tq{ENTER}

;Set up End It All
Run C:\Program Files\EndItAll\EndItAll.exe
WinWait, End It All, 
IfWinNotActive, End It All, , WinActivate, End It All, 
WinWaitActive, End It All, 
MouseClick, left,  80,  340 ;Terminate all unnecessary programs
Sleep, 100

;Set up NR2003
Run C:\Papyrus\NASCAR Racing 2003 Season\NR2003.exe
WinWait, NASCAR Racing 2003 Season, 
IfWinNotActive, NASCAR Racing 2003 Season, , WinActivate, NASCAR Racing 2003 Season, 
WinWaitActive, NASCAR Racing 2003 Season,