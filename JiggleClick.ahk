#include FcnLib.ahk

;Jiggle-click!

Loop
{
   MouseMove, 5, 0, , R
   Click
   Sleep, 500
   MouseMove, -5, 0, , R
   Click
   Sleep, 5000
}

;TODO exit confirmation box
`::
ESC::
ExitApp
Return
