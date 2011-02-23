#include FcnLib.ahk

RunOpera()
{
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
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   Send, !d
   Sleep, 100
   Send, %url%
   oldTitle:=WinGetActiveTitle()
   Send, {ENTER}
   WinWaitActiveTitleChange(oldTitle)
   ;ShortSleep()
   Sleep, 500
   ;TODO change this back to a long sleep if that broke anything
}

;Wait until the title of the active window changes
;(note that changing to another window sets it off, too)
WinWaitActiveTitleChange(oldTitle="")
{
   ;if they didn't give a title, try to grab the title as quickly as possible
   ;this is less reliable, but if we don't have the title, we'll just do the best we can
   if (oldTitle == "")
      WinGetActiveTitle, oldTitle
   ;loop until the window title changes
   Loop
   {
      WinGetActiveTitle, newTitle
      if (oldTitle != newTitle)
         break
      Sleep, 100
   }
}

