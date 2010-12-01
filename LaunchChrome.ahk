#include FcnLib.ahk

if ( A_ComputerName == "PHOSPHORUS" )
{
   Send, #1
   ForceWinFocus("Chrome", "Contains")
   WaitForImageSearch("images/chrome/reopenTabsIcon.bmp", "Control")
   ClickIfImageSearch("images/chrome/reopenTabsIcon.bmp", "Control")
   Sleep, 500
   Send, ^!{NUMPAD5}
}
