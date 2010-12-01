#include FcnLib.ahk
#singleinstance force

; Build GUI.
Gui, Add, Listview, xm ym w200 h120 Grid AltSubmit vM095_ListViewVar gM095_ListViewSelect, ID|Comment
filename=%A_WorkingDir%\todo\tasklist.txt

Loop, read, %filename%
{
    LV_Add( "", A_Index, A_LoopReadLine )
}
Gui, Show, , MyApp

Return ; End of auto-execute section.


MO_95:
{
    MyFocusedRow := LV_GetNext( "", "Focused" )
    LV_GetText( M095_gThoughtID, MyFocusedRow, 1 )
    MsgBox, % "ID: " . M095_gThoughtID
}
Return


M095_ListViewSelect:
{
    If ( A_GuiEvent = "DoubleClick" )
    {
        GoSub, MO_95
    }
}
Return


GuiClose:
GuiEscape:
{
    ExitApp
}
Return


; Define app-sensitive hotkeys.
#IfWinActive, MyApp
{
    ~NumpadEnter::
    ~Enter::
    {
        GuiControlGet, FocusedControl, FocusV
        If ( FocusedControl = "M095_ListViewVar" )
        {
            GoSub, MO_95
        }
    }
    Return
}
#IfWinActive

