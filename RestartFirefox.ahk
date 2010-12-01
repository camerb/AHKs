#include FcnLib.ahk

Process, Close, firefox.exe
Sleep, 10000
Run, firefox.exe
ForceWinFocus("Mozilla Firefox")
Sleep, 1000
IfWinActive, Firefox Updated
   Send, ^w
Sleep, 1000
Send, ^1
Sleep, 1000
Send, {ENTER}
Sleep, 100
Send, ^!2
