#include FcnLib.ahk

RunWait, HideSkSync.ahk

;Tell the logitech profiler to go into NR2003 mode so that I don't have combined pedals
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
