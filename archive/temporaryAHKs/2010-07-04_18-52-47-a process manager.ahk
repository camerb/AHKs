#include FcnLib.ahk
;http://www.autohotkey.com/forum/viewtopic.php?t=59801
DetectHiddenWindows, On

Gui, Add, ListView, r20 w500 gMyListView, Name|pid
WinGet, List, List, ahk_class AutoHotkey
gosub load_data
return

load_data:
LV_Delete()
Loop %List%
{
    WinGet, PID, PID, % "ahk_id " List%A_Index%
    If ( PID <> DllCall("GetCurrentProcessId") )
    {
    Wingettitle,name,% "ahk_id " List%A_Index%
    LV_Add("", Name, pid)
    msgbox,,, %pid%, 1
    }
}
LV_ModifyCol()
LV_ModifyCol(2,80)

LV_ModifyCol(2, "Integer center")
Gui, Show,autosize
return

MyListView:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo,2)
    msgbox,260,,%rowtext% kill application?
    IfMsgBox, yes
    {
    ;Process, close,%rowtext%
   PostMessage,0x111,65405,0,,ahk_pid %rowtext%
    sleep 2000
    gosub load_data
    }
}

return

GuiClose:
ExitApp

