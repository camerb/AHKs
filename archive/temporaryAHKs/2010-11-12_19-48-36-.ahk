#include FcnLib.ahk

;WinShow, Logitech Profiler

Run, "C:\Program Files\Logitech\Profiler\LWEmon.exe"
ForceWinFocus("Logitech Profiler")
;Send, {ALT}ps{ENTER}
Send, {ALT}
Sleep, 100
Send, p
Sleep, 100
Send, s
Sleep, 100
Send, {ENTER}
Sleep, 100
WinClose, Logitech Profiler

