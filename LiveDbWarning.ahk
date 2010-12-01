#include FcnLib.ahk

overlayMessage("You are connected to the LIVE DB")
;debug("You are connected to the LIVE DB")
ExitApp

;TODO make an ahk that is singleinstance, and
;TODO show these messages in the corner of the screen
;TODO show overlapping messages nicely
overlayMessage(message)
{
        CustomColor = 000000
        Gui, 2:+LastFound -Caption +ToolWindow +AlwaysOnTop
        Gui, 2:Color, %CustomColor%
        Gui, 2:Font, s36
        Gui, 2:Add, Text, cRed, %message%
        WinSet, TransColor, %CustomColor% 150
        Gui, 2:Show, NoActive
SleepSeconds(5)
WinClose
}
