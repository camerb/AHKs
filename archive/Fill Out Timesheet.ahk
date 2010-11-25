WinWait ahk_class SALFRAME
IfWinNotActive ahk_class SALFRAME
WinActivate ahk_class SALFRAME
WinWaitActive ahk_class SALFRAME
Send, {RIGHT}{CTRLDOWN}c{CTRLUP}
Sleep 100

WinWait ADP ezLaborManager - Employee Time Sheet - Google Chrome
IfWinNotActive ADP ezLaborManager - Employee Time Sheet - Google Chrome
WinActivate ADP ezLaborManager - Employee Time Sheet - Google Chrome
WinWaitActive ADP ezLaborManager - Employee Time Sheet - Google Chrome
MouseClick, left,  356,  176
Sleep, 100
Send, {CTRLDOWN}av{CTRLUP}
MouseClick, left,  480,  178
Sleep, 100
Send, {CTRLDOWN}av{CTRLUP}
MouseClick, left,  575,  181

WinWait ahk_class SALFRAME
IfWinNotActive ahk_class SALFRAME
WinActivate ahk_class SALFRAME
WinWaitActive ahk_class SALFRAME
Send, {HOME}{CTRLDOWN}c{CTRLUP}{DOWN}
Sleep 2000

WinWait ADP ezLaborManager - Employee Time Sheet - Google Chrome
IfWinNotActive ADP ezLaborManager - Employee Time Sheet - Google Chrome
WinActivate ADP ezLaborManager - Employee Time Sheet - Google Chrome
WinWaitActive ADP ezLaborManager - Employee Time Sheet - Google Chrome
MouseClick, left,  301,  332
Send, {CTRLDOWN}v{CTRLUP}
MouseClick, left,  51,  267