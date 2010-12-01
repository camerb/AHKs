#include FcnLib.ahk

if (A_ComputerName="PHOSPHORUS")
{
   Send, {BROWSER_FORWARD}
   Send, {BROWSER_BACK}
   if ForceWinFocusIfExist("Google Chrome")
      Send, ^!1
   if ForceWinFocusIfExist("Mozilla Firefox")
      Send, ^!2
   ;Sleep, 100
}
