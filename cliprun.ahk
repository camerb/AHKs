#include FcnLib.ahk

Class := "Window"

WinGetPos X, Y, W, H, ahk_class %Class%
Z := Y+H
Gui 1:-SysMenu
Gui 1:+Resize
Gui 1:Add, ListBox, vLabel W%W% R4
Gui 1:-Resize
Gui 1:Show, NA X%X% Y%Y%, Status

AStatus(Input)
{
	Global
	If (StrLen(Input) > 0)
	{
		Gui 1:Show, NA X%X% Y%Z%
		GuiControl Text, Label, %Input%
		Return True
	}
	Return False
}

AStatus("Something happened...")



 ~esc::ExitApp