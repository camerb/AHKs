#include FcnLib.ahk

WinGetPos, xPos, no, no, winHeight, ahk_class SideBarWndv10
;debug(xpos, winheight)
if (xPos < 2500)
{
   ;debug()
   WinActivate, ahk_class SideBarWndv10
   Click(20, winHeight - 20, "Right")
   Sleep, 100
   Send, {DOWN 2}{ENTER}

   WinWaitActive, Options
   ;ForceWinFocus("Options")
   MouseClick, left,  95,  41
   Sleep, 100
   MouseClick, left,  390,  249
   Sleep, 100
   MouseClick, left,  401,  279
   Sleep, 100
   MouseClick, left,  239,  553
   Sleep, 100
   ;debug()
}

