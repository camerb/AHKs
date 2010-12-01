#include FcnLib.ahk

;WinWait, Mozilla Firefox,
;IfWinNotActive, Mozilla Firefox, , WinActivate, Mozilla Firefox,
;WinWaitActive, Mozilla Firefox,
;MouseClick, left,  483,  336
;Sleep, 100
;Send, {F5}
;MouseClick, left,  483,  336
;Sleep, 100
;Send, {CTRLDOWN}s{CTRLUP}
;WinWait, Save As,
;IfWinNotActive, Save As, , WinActivate, Save As,
;WinWaitActive, Save As,
;Send, qb.txt{ENTER}
;WinWait, Confirm Save As,
;IfWinNotActive, Confirm Save As, , WinActivate, Confirm Save As,
;WinWaitActive, Confirm Save As,
;MouseClick, left,  69,  9
;Sleep, 100
;Send, y
;;MouseClick, left,  816,  1035
;Sleep, 100
;WinWait, qb.txt and download.txt - Perforce P4Merge,
;IfWinNotActive, qb.txt and download.txt - Perforce P4Merge, , WinActivate, qb.txt and download.txt - Perforce P4Merge,
;WinWaitActive, qb.txt and download.txt - Perforce P4Merge,
;MouseClick, left,  582,  20
;Sleep, 100
;MouseClick, left,  36,  59




WinWait, Opening xls,
IfWinNotActive, Opening xls, , WinActivate, Opening xls,
WinWaitActive, Opening xls,
MouseClick, left,  103,  16
Sleep, 100
MouseClick, left,  294,  279
Sleep, 1500
FileMove, C:\Users\cameron\Documents\Downloads\xls, C:\Users\cameron\Documents\Downloads\xls.xls, 1
Sleep, 1500
Run, C:\Users\cameron\Documents\Downloads\xls.xls
;WinWait, Downloads,
;IfWinNotActive, Downloads, , WinActivate, Downloads,
;WinWaitActive, Downloads,
;MouseClick, left,  111,  20
;Sleep, 100
;MouseClick, left,  438,  11
;Sleep, 100




ForceWinFocus("Downloads ahk_class MozillaUIWindowClass", "Exact")
WinClose
