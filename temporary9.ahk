#include FcnLib.ahk

Loop
{
if InStr(WinGetActiveTitle(), "Freenode")
   ExitApp

MouseClick, left,  1297,  172
Sleep, 1000
MouseClick, left,  1697,  172
Sleep, 1000
MouseClick, left,  1701,  181
Sleep, 1000
MouseClick, left,  1606,  639
;WinWaitActiveTitleChange()
Sleep, 9000
MouseClick, left,  844,  361
;WinWaitActiveTitleChange()
Sleep, 9000
Send, {CTRLDOWN}w{CTRLUP}
}

ESC::ExitApp
