#include FunctionLibrary.ahk



Gui:
   Gui, +ToolWindow
   Gui, Add, Text, w100 v_MyText
   Gui, Show
   SetTimer, MB, 10000
   Start := Sec() + 10
   Loop
   {
      If (Label)
         Break
      If (Start - Sec() < 0)
      {
         GuiControl,, _MyText, %   Round(Start - Sec(), 3)
         Break
      }
      GuiControl,, _MyText, % Round(Start - Sec(), 3)
      Sleep, 200
   }
Return


MB:
   Label := 1
   MsgBox, % Round(Start - Sec(), 3)
   SetTimer, MB, Off
Return

Sec()
{
   Return Mod(A_TickCount / 1000, 60)
}



;var:=rand()
;Gui, Add, Text,, hello, hello, hello, %var%
;Gui, Show



;rand()
;{
;var:=random(100, 999)
;return var
;}
