#include FcnLib.ahk

FileDelete("allWindows.txt")

; Example #2: This will visit all windows on the entire system and display info about each of them:
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    SetTitleMatchMode, fast
    WinGet, this_hwndid, ID, ahk_id %this_id%
    WinGet, this_pid, PID, ahk_id %this_id%
    WinGet, this_processname, ProcessName, ahk_id %this_id%

    ;seriously? is this necessary?
    ;WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    WinGetText, this_text, ahk_id %this_id%
    SetTitleMatchMode, slow
    WinGetTitle, this_title_slow, ahk_id %this_id%
    WinGetText, this_text_slow, ahk_id %this_id%

    msg=Visiting All Windows...==========================================
    msg2=`n%a_index% of %id%`nProcessName: %this_ProcessName%`nHWND_ID (aka ahk_id): %this_hwndid%`nPID: %this_pid%`nahk_class %this_class%`nTitle: %this_title%`nText: %this_text%`nTitle slow: %this_title_slow%`nText slow: %this_text_slow%`n`n
    msg := msg . msg2
    ;MsgBox, 4, , %msg%
    ;IfMsgBox, NO, break
    FileAppend, `n%msg%, allWindows.txt
}

