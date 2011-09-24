#include FcnLib.ahk

OnExit, EXITSUB
Gui, 2:FONT, s14, Arial
Gui, 2:ADD, TEXT, w160 h180 Wrap, Click Loop Button to count`nCTRL SPACE to Pause.
Gui, 2:show, w180 h100 NA,Status
WinGetPos,x,,,,Status
Winmove,Status,,% x+250
Gui, Add, Button,x+25 y+30 vloop1 gLOOP, LOOP1
Gui, Add, Button,x+25 vloop2 gLOOP, LOOP2
Gui, Show,w200 h100,Test Script
RETURN

LOOP:
;PRETEND THIS LOOP IS 1000 LINES OF CODE! IF THEN RETURN STATEMENTS AREN'T THE SOLUTION I'M LOOKING FOR!!
Loop 
{
ControlSetText,static1,%A_Index%,Status
Sleep, 1000
}
EXIT

GUICLOSE:
GUIESCAPE:
CANCEL:
EXITSUB:
ExitApp
EXIT

^Space::
RELOAD
RETURN
^R::RELOAD
^q::EXITAPP



 ~esc::ExitApp