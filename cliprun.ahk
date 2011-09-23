#include FcnLib.ahk

Gui, Margin, 0, 0
Gui, Add, Picture, vPic1 w100 h100 x1 y1
Gui, Add, Picture, vPic2 w100 h100 x1 y1
Gui, Show
Sleep, 1000
Loop
{
  N := (N=10) ? 10 : 10
  GuiControl,, Pic1, *icon%N% C:\WINDOWS\system32\shell32.dll
  Sleep, 50
  GuiControl,, Pic2, *icon%N% C:\WINDOWS\system32\shell32.dll
  Sleep, 150
}



 ~esc::ExitApp