;#include FcnLib.ahk

   MsgBox, Hello World
   MsgBox, 16, Critical Error, An unspecified error has occurred
   MsgBox, , Timeout MsgBox, This box will disappear after 3 seconds, 3
MsgBox, 16, hello, hi

Loop, 5
{
   MsgBox, %A_Index%
}
msgbox, 0x10, hello, hi

`::ExitApp
