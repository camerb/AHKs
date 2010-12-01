#include FcnLib.ahk

message("msg")

;TODO put this in a function
;TODO make an ahk that is singleinstance, and
;TODO show these messages in the corner of the screen
;TODO show overlapping messages nicely
message(message)
{
CustomColor = 333333
Gui, 2:+LastFound -Caption +ToolWindow +AlwaysOnTop
Gui, 2:Color, %CustomColor%
Gui, 2:Font, s32
;Gui, 2:Font, ComicSans
Gui, 2:Add, Text, cWhite, %message%
WinSet, TransColor, %CustomColor% 150
Gui, 2:Show, NoActive
WinMove, ahk_class AutoHotkeyGUI, , 450, 685, 317, 99
SleepSeconds(2)
WinClose
}
