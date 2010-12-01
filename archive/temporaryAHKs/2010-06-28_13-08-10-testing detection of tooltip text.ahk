#include FcnLib.ahk


SetTitleMatchMode 2

;this never seems to work, but resembles what i want my code to look like
IfWinExist, ahk_class tooltips_class32, Automatic Updates is turned off
{
   WinClose
   MsgBox, #1 Closed TT XP Updates
}
IfWinExist, ahk_class tooltips_class32, A new version of Java is ready to be installed.
{
   WinClose
   MsgBox, #2 Closed TT Java
}

;This works, but is a little verbose
IfWinExist, ahk_class tooltips_class32
{
   WinGet, ID, LIST,ahk_class tooltips_class32
   Loop, %id%
   {
      this_id := id%A_Index%
      ControlGetText, tttext,,ahk_id %this_id%
      if (InStr(tttext, "Automatic Updates is turned off"))
      {
         WinClose ahk_id %this_id%
         MsgBox, #3 Closed TT XP Updates (Detected using Generic)
      }
      if (InStr(tttext, "A new version of Java is ready to be installed."))
      {
         WinClose ahk_id %this_id%
         MsgBox, #4 Closed TT Java (Detected using Generic)
      }
   }
}

;Close all traytips that were not caught by the other methods
IfWinExist, ahk_class tooltips_class32
{
   WinClose
   MsgBox, #5 Closed TT (Generic as a last resort -- this should never happen)
}
