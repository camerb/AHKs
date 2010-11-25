SetTitleMatchMode 2

WinWait, CoffeeCup HTML Editor
IfWinNotActive, CoffeeCup HTML Editor, , WinActivate, CoffeeCup HTML Editor
WinWaitActive, CoffeeCup HTML Editor

MouseClick, left,  91,  26
Sleep, 100
Send, {CTRLDOWN}s{CTRLUP}{CTRLDOWN}{SHIFTDOWN}s{SHIFTUP}{CTRLUP}
WinWait, Save As,
IfWinNotActive, Save As, , WinActivate, Save As,
WinWaitActive, Save As,
Sleep 100

WinWaitActive, CoffeeCup HTML Editor
Send, s

WinWait, OpenOffice.org Impress,
IfWinNotActive, OpenOffice.org Impress, , WinActivate, OpenOffice.org Impress,
WinWaitActive, OpenOffice.org Impress,
MouseClick, left,  202,  990
Sleep, 100
MouseClick, left,  142,  982
Sleep, 100



WinWait, CoffeeCup HTML Editor
IfWinNotActive, CoffeeCup HTML Editor, , WinActivate, CoffeeCup HTML Editor
WinWaitActive, CoffeeCup HTML Editor
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}{CTRLUP}{DEL}
WinWait, OpenOffice.org Impress,
IfWinNotActive, OpenOffice.org Impress, , WinActivate, OpenOffice.org Impress,
WinWaitActive, OpenOffice.org Impress,
MouseClick, left,  324,  24
Sleep, 100
MouseClick, left,  374,  338
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
WinWait, RegEx File Processor,
IfWinNotActive, RegEx File Processor, , WinActivate, RegEx File Processor,
WinWaitActive, RegEx File Processor,
MouseClick, left,  222,  226
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}regex2.txt
Sleep, 100
MouseClick, left,  84,  148
Sleep, 100
MouseClick, left,  188,  136
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}{SHIFTDOWN}{SHIFTUP}v{SHIFTDOWN}{SHIFTUP}{CTRLUP}
MouseClick, left,  40,  158
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}
MouseClick, left,  88,  144
Sleep, 100
MouseClick, left,  378,  518
Sleep, 100
MouseClick, left,  316,  452
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
WinWait, CoffeeCup HTML Editor
IfWinNotActive, CoffeeCup HTML Editor, , WinActivate, CoffeeCup HTML Editor
WinWaitActive, CoffeeCup HTML Editor
Send, {CTRLDOWN}v{home}{CTRLUP}

WinWait, OpenOffice.org Impress,
IfWinNotActive, OpenOffice.org Impress, , WinActivate, OpenOffice.org Impress,
WinWaitActive, OpenOffice.org Impress,
MouseClick, left,  528,  438
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}

Run, "C:\Program Files (x86)\OpenOffice.org 3\program\swriter.exe"
WinWait, OpenOffice.org Writer,
IfWinNotActive, OpenOffice.org Writer, , WinActivate, OpenOffice.org Writer,
WinWaitActive, OpenOffice.org Writer,
MouseClick, left,  496,  242
Sleep, 100
MouseClick, left,  482,  368
Sleep, 100
Send, {CTRLDOWN}v{CTRLUP}{CTRLDOWN}{SHIFTDOWN}s{SHIFTUP}{CTRLUP}


WinWait, Save As,
IfWinNotActive, Save As, , WinActivate, Save As,
WinWaitActive, Save As,
MouseClick, left,  128,  22
Sleep, 100
MouseClick, left,  46,  122
Sleep, 100
MouseClick, left,  414,  304
Sleep, 100
MouseClick, left,  392,  314
Sleep, 100
MouseClick, left,  366,  308
MouseClick, left,  366,  308
Sleep, 100

WinWait, Save As,
IfWinNotActive, Save As, , WinActivate, Save As,
WinWaitActive, Save As,
MouseClick, left,  82,  16
Sleep, 100
MouseClick, left,  530,  400
Sleep, 100
WinWait, Save As,
IfWinNotActive, Save As, , WinActivate, Save As,
WinWaitActive, Save As,
MouseClick, left,  434,  627
Sleep, 100
MouseClick, left,  384,  249

;choose to overwrite
WinWait, Confirm Save As,
IfWinNotActive, Confirm Save As, , WinActivate, Confirm Save As,
WinWaitActive, Confirm Save As,
MouseClick, left,  234,  109
Sleep, 100
WinWait, temp.html - OpenOffice.org Writer,
IfWinNotActive, temp.html - OpenOffice.org Writer, , WinActivate, temp.html - OpenOffice.org Writer,
WinWaitActive, temp.html - OpenOffice.org Writer,
MouseClick, left,  324,  20
Sleep, 100
MouseClick, left,  1216,  14
Sleep, 100
WinWait, CoffeeCup HTML Editor
IfWinNotActive, CoffeeCup HTML Editor, , WinActivate, CoffeeCup HTML Editor
WinWaitActive, CoffeeCup HTML Editor
MouseClick, left,  100,  8
Sleep, 100
MouseClick, left,  88,  72
Sleep, 100
MouseClick, left,  126,  96
Sleep, 100
SetTitleMatchMode, 1
WinWait, Open,
IfWinNotActive, Open, , WinActivate, Open,
WinWaitActive, Open,
SetTitleMatchMode, 2
Click, 50, 150
Sleep 100
Send, temp.html
MouseClick, left,  522,  371
Sleep, 100
WinWait, CoffeeCup HTML Editor - C:\Users\cameron\Desktop\temp.html,
IfWinNotActive, CoffeeCup HTML Editor - C:\Users\cameron\Desktop\temp.html, , WinActivate, CoffeeCup HTML Editor - C:\Users\cameron\Desktop\temp.html,
WinWaitActive, CoffeeCup HTML Editor - C:\Users\cameron\Desktop\temp.html,
MouseClick, left,  214,  410
Sleep, 100
Send, {CTRLDOWN}{SHIFTDOWN}{END}{SHIFTUP}{CTRLUP}{CTRLDOWN}c{CTRLUP}
MouseClick, right,  280,  972
Sleep, 100
MouseClick, left,  298,  988
Sleep, 100
WinWait, RegEx File Processor,
IfWinNotActive, RegEx File Processor, , WinActivate, RegEx File Processor,
WinWaitActive, RegEx File Processor,
MouseClick, left,  92,  146
Sleep, 100
MouseClick, left,  286,  150
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}{SHIFTDOWN}{SHIFTUP}v{CTRLUP}
MouseClick, left,  222,  226
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}regex3.txt

WinWait, RegEx File Processor,
IfWinNotActive, RegEx File Processor, , WinActivate, RegEx File Processor,
WinWaitActive, RegEx File Processor,
MouseClick, left,  370,  518
Sleep, 100
MouseClick, left,  344,  438
Sleep, 100
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}

WinWait, CoffeeCup HTML Editor
IfWinNotActive, CoffeeCup HTML Editor, , WinActivate, CoffeeCup HTML Editor
WinWaitActive, CoffeeCup HTML Editor
MouseClick, left,  338,  471
Sleep, 100
Send, {CTRLDOWN}v{CTRLUP}{CTRLDOWN}s{CTRLUP}
