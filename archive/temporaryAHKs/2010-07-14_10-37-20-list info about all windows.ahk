#include FcnLib.ahk

; Example #2: This will visit all windows on the entire system and display info about each of them:
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    WinGetText, this_text, ahk_id %this_id%
    msg=Visiting All Windows`n%a_index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n%this_text%`n`nContinue?
    ;MsgBox, 4, , %msg%
    ;IfMsgBox, NO, break
    FileAppend, `n%msg%, allWindows.txt
}

