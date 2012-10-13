#include FcnLib.ahk


   ;CustomTitleMatchMode("Exact")
   debug()
   ForceWinFocus("Control Panel ahk_class G2WHeadPane")
   debug(2)
   tit:=WinGetActiveTitle()
   debug(tit)
   IfWinActive, Control Panel ahk_class G2WHeadPane
   {
      if ClickIfImageSearch("images\GoToMeeting\newPersonInMeeting.bmp", "Right")
      {
         Sleep, 100
         Send, {DOWN 2}
         Sleep, 100
         Send, {ENTER}
      }
   }

   CustomTitleMatchMode("Default")
