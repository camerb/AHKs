#include FcnLib.ahk

Gx := 0
Sx := 0
xpos := -125
ypos := 0

Gen:
  Gx := ++Gx
  Sx := ++Sx
  xpos := xpos + 125
  If xpos >= %A_ScreenWidth%
    {
      xpos := 0
      ypos := ypos + 125
    }
  GoSub Sx
return

Sx:
  Gui, %Gx%:-SysMenu -Caption
  Gui, %Gx%:Font,, Helvetica
  Gui, %Gx%:Add, Text,, Gui %Gx%`nSome text
  Gui, %Gx%:Add, Edit, w95, Subroutine: %Sx%
  Gui, %Gx%:Add, Button, gClose v%Gx%, x
  Gui, %Gx%:Show, x%xpos% y%ypos%
  MsgBox Gui %Gx% completed
  GoSub Gen
return

Close:
  y := A_GuiControl
  Gui, %y%:Destroy
return

