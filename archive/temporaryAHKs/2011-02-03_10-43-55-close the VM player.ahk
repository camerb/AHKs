#include FcnLib.ahk

if ForceWinFocusIfExist("ahk_class VMPlayerFrame")
{
   Sleep, 500
   ForceWinFocus("ahk_class VMPlayerFrame")
   Send, {ALT}fx
}
