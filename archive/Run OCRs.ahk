Run, C:\Program Files\Commander\TOTALCMD.EXE
Sleep 200
WinWait, cbaustian^ - Total Commander 7.01 - Stephen Gordon, 
IfWinNotActive, cbaustian^ - Total Commander 7.01 - Stephen Gordon, , WinActivate, cbaustian^ - Total Commander 7.01 - Stephen Gordon, 
WinWaitActive, cbaustian^ - Total Commander 7.01 - Stephen Gordon, 
MouseClick, left,  256,  17
MouseClick, left,  256,  17
Sleep, 100

MouseClick, left,  28,  115
Sleep, 800
MouseClick, left,  28,  115
Sleep, 100
Send, ^aD:\ocrtmp\{ENTER}
Sleep 300

MouseClick, left,  607,  116
Sleep, 1000
MouseClick, left,  607,  116
Sleep, 1000
;SendInput, ^a\\ia-005\FAX\HHSC\
SendInput, ^a\\ia-005\FAX\RREH\
Sleep 1000
SendInput {ENTER 2}
Sleep 500

Send, {CTRLDOWN}a
Sleep 100
MouseClick, right,  630,  162
Sleep, 100
Send, {CTRLUP}

SendInput {F6}{Enter}

;###

MouseClick, left,  617,  166
MouseClick, left,  617,  166
Sleep, 100
MouseClick, left,  288,  177
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{ALTDOWN}{F5}{ALTUP}
WinWait, Pack files, 
IfWinNotActive, Pack files, , WinActivate, Pack files, 
WinWaitActive, Pack files, 
MouseClick, left,  216,  55
Sleep, 100
FormatTime CurrentDateTime,, MMddyyyy
SendInput {CTRLDOWN}a{CTRLUP}zip:\\ia-005\FAX\HHSC\processed\%CurrentDateTime%.zip
Sleep 5000

MouseClick, left,  318,  162
Sleep, 100
Send, {F7}
WinWait, Total Commander, 
IfWinNotActive, Total Commander, , WinActivate, Total Commander, 
WinWaitActive, Total Commander, 
Send, output{Enter}

;WinWait, Form1, 
;IfWinNotActive, Form1, , WinActivate, Form1, 
;WinWaitActive, Form1, 
;MouseClick, left,  1011,  9
;Sleep, 100
;WinWait, , 
;IfWinNotActive, , , WinActivate, , 
;WinWaitActive, , 
;MouseClick, left,  549,  834
;Sleep, 100
