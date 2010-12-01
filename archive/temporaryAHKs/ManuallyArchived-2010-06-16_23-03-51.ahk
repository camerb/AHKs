#include FcnLib.ahk

Gui, Add, Edit  , w200 h100 vMyEdit_1   gCopyText  ,
Gui, Add, Edit  , w200 h100 vMyEdit_2   gCopyText  ,
Gui, Add, Edit  , w200 h100 vMyEdit_3              ,
Gui, Add, Button, w200 h25  vMyButton_1 gGetLineNum, Get caret line
Gui, Show
Return

CopyText:
{
    Gui, 1: Submit, NoHide
    MyText := MyEdit_1 . MyEdit_2
    GuiControl, Text, MyEdit_3, % MyText
}
Return


GetLineNum:
{
    ControlGet, CurrLine, CurrentLine, , Edit3
    MsgBox, % CurrLine
}
Return


GuiClose:
GuiEscape:
{
    ExitApp
}
Return

