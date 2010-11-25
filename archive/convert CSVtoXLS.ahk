Run, C:\Program Files\OpenOffice.org 3\program\scalc.exe
WinWait, Untitled 1 - OpenOffice.org Calc, 
IfWinNotActive, Untitled 1 - OpenOffice.org Calc, , WinActivate, Untitled 1 - OpenOffice.org Calc, 
WinWaitActive, Untitled 1 - OpenOffice.org Calc, 
MouseClick, left,  123,  20
Sleep, 100
MouseClick, left,  17,  37
Sleep, 100
MouseClick, left,  229,  10
Sleep, 100
Send, {CTRLDOWN}o{CTRLUP}
WinWait, Open, 
IfWinNotActive, Open, , WinActivate, Open, 
WinWaitActive, Open, 
Send, {CTRLDOWN}v{CTRLUP}
MouseClick, left,  472,  474
Sleep, 100
Send, {ENTER}
WinWait, testcsvinput.csv - OpenOffice.org Calc, 
IfWinNotActive, testcsvinput.csv - OpenOffice.org Calc, , WinActivate, testcsvinput.csv - OpenOffice.org Calc, 
WinWaitActive, testcsvinput.csv - OpenOffice.org Calc, 
MouseClick, left,  14,  42
Sleep, 100
MouseClick, left,  339,  13
Sleep, 100
Send, {CTRLDOWN}{SHIFTDOWN}{SHIFTUP}{CTRLUP}
MouseClick, left,  339,  13
Sleep, 100
Send, {CTRLDOWN}{SHIFTDOWN}{SHIFTUP}{CTRLUP}