#include FcnLib.ahk

;Move the mouse across the entire screen

SetDefaultMouseSpeed, 12

SleepSeconds(2)

height := A_ScreenHeight
width := A_ScreenWidth

Loop %height%
{
MouseMove, 0, %A_Index%
MouseMove, %Width%, %A_Index%
;Sleep, 50
}

ExitApp
`:: ExitApp
