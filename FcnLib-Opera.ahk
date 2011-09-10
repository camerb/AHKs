#include FcnLib.ahk

;a more specialized version of runprogram("opera")?
RunOpera()
{
   oldPath=C:\Program Files\Opera\opera.exe
   newPath=C:\Program Files (x86)\Opera\opera.exe
   if FileExist(oldPath)
      Run, %oldPath%
   else if FileExist(newPath)
      Run, %newPath%

   ;TODO kill users command
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")

   if ForceWinFocusIfExist("Cannot start Opera")
   {
      while ProcessExist("opera.exe")
         ProcessClose("opera.exe")
   }

   if ForceWinFocusIfExist("Welcome to Opera ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   {
      Send, {ENTER}
      ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   }
}

CloseAllTabs()
{
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   Send, ^w
   Sleep, 100
   while (WinGetActiveTitle() != "Speed Dial - Opera")
   {
      Send, ^w
      Sleep, 100
   }
   if (WinGetActiveTitle() == "Downloads - Opera")
      Send, ^w
}

GoToPage(url)
{
   if (url = "known")
      url=http://dl.dropbox.com/u/789954/KnownTitle.html

   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   Send, !d
   Sleep, 100
   Send, %url%
   oldTitle:=WinGetActiveTitle()
   Send, {ENTER}
   WinWaitActiveTitleChange(oldTitle)
   Sleep, 500
}

