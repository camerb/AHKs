#include firefly-FcnLib.ahk
#singleinstance force

;This script helps us deal with those things/errors that could pop up at any time

FireflyCheckin("Helper", "Started")

;{{{Persistent items (things that are checked repetitively)
Loop
{
   if SimpleImageSearch("images/firefly/dialogWhite/thereWasAnErrorHandlingYourCurrentActionVM.bmp")
      ClickIfImageSearch("images/firefly/dialog/okButton.bmp")

   win=You're the Presenter - GoToMeeting
   IfWinExist, %win%
   {
      ForceWinFocus(win)
      Send, {ENTER}
   }
   win=Unable to Join Session - GoToMeeting
   IfWinExist, %win%
   {
      ;This meeting ID has expired. Please check with the meeting organizer.
      ForceWinFocus(win)
      Send, {ENTER}
   }
   win=Keyboard and Mouse Control Request - GoToMeeting
   IfWinExist, %win%
   {
      ForceWinFocus(win)
      Send, {ENTER}
   }
   win=Control Panel ahk_class G2WHeadPane
   IfWinExist, %win%
   {
      ForceWinFocus(win)
      Click, -20, 45
   }

   Sleep, 100

   if (A_Sec = 0)
      FireflyCheckin("Helper", "Watching")
}

return
;}}}
