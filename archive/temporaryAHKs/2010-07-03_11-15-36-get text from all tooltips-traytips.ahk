#include FcnLib.ahk

WinGet, ID, LIST,ahk_class tooltips_class32
tt_text=
Loop, %id%
{
  this_id := id%A_Index%
  ControlGetText, tooltip2,,ahk_id %this_id%
  tt_text.= "******************`n" tooltip2 "`n******************`n"
}

;tooltip, %tt_text%, 300, 300
FileAppend, `nToolTip Text:%tt_text%`n`n, allWindows.txt
msgbox, %tt_text%


