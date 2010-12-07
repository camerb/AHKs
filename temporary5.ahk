#include FcnLib.ahk


;ForceReloadAll()
;message(addTime("20100000000000", "000300010000"))


addTime(time1, time2)
{
EnvAdd, time1, %time2%
return time1
}

subTime()
{

return returned
}

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

saferestart()
{
path=C:\DataExchange\tempRestart.txt

;write file with sleep, restart
FileAppend, `n`nSleep, 5000`nRun, restart.ahk,
;run file with sleep restart
Run, %path%
SelfDestruct()
}
