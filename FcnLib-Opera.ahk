#include FcnLib.ahk

RunOpera()
{
   ;Run opera
   oldPath=C:\Program Files\Opera\opera.exe
   newPath=C:\Program Files (x86)\Opera\opera.exe
   if FileExist(oldPath)
      Run, %oldPath%
   else if FileExist(newPath)
      Run, %newPath%

   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
}

CloseAllTabs()
{
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   while (WinGetActiveTitle() != "Speed Dial - Opera")
   {
      Send, ^w
      Sleep, 100
   }
}
