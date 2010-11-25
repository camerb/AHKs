;An old hotkey for installing a .tar from cpan
;note that FM is 7zip
WinWait, ahk_class FM
IfWinNotActive,  ahk_class FM, , WinActivate,  ahk_class FM
WinWaitActive, ahk_class FM

Sleep, 100
MouseClick, left,  25,  164
MouseClick, left,  25,  164
Sleep, 100

WinGetTitle, titletext

MouseClick, left,  83,  78
Sleep, 100
WinWait, Copy,
IfWinNotActive, Copy, , WinActivate, Copy,
WinWaitActive, Copy,

WinGetText, windowtext

Sleep, 100
MouseClick, left,  371,  270
Sleep, 100

WinWait, C:\Windows\system32\cmd.exe,
IfWinNotActive, C:\Windows\system32\cmd.exe, , WinActivate, C:\Windows\system32\cmd.exe,
WinWaitActive, C:\Windows\system32\cmd.exe,

cdfilepath:=RegExMatch(windowtext,"C:\\.*")

;Debug(windowtext)
;Debug(cdfilepath)

Send, cd{SPACE}%titletext%

Sleep, 100

;Send, cpan{SPACE}.{ENTER}
return