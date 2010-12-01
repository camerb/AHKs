#include FcnLib.ahk
#singleinstance force

; Build GUI.
Gui, Add, Listview, xm ym w200 h120 Grid AltSubmit vM095_ListViewVar gM095_ListViewSelect, ID|Comment|File
filename=%A_WorkingDir%\todo\tasklist.txt

Loop, %A_WorkingDir%\todo\*
{
   FileReadLine, var, %A_LoopFileFullPath%, 1
   LV_Add( "", A_Index, var, A_LoopFileFullPath )
}
Gui, Show, , MyApp

Return ; End of auto-execute section.


MO_95:
{
    ;MyFocusedRow := LV_GetNext( "", "Focused" )
    ;LV_GetText( M095_gThoughtID, MyFocusedRow, 3 )
    ;MsgBox, % "File Path: " . M095_gThoughtID
    ;InputBox, var , Edit Task, What should the new text for this task be?, , , , , , , , %M095_gThoughtID%

    MyFocusedRow := LV_GetNext( "", "Focused" )
    LV_GetText( text, MyFocusedRow, 2 )
    LV_GetText( M095_gThoughtID, MyFocusedRow, 3 )
    ;MsgBox, % "File Path: " . M095_gThoughtID
    InputBox, var , Edit Task, What should the new text for this task be?, , , , , , , , %text%
    ;msgbox, %M095_gThoughtID%
    FileDelete, %M095_gThoughtID%
    Sleep 500
    FileAppend, %text%, %M095_gThoughtID%
    reload
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

