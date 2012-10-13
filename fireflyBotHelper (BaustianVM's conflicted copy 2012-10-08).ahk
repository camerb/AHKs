#include firefly-FcnLib.ahk
#singleinstance force

;This script helps us deal with those things/errors that could pop up at any time

FireflyCheckin("Helper", "Started")

;{{{Persistent items (things that are checked repetitively)
Loop
{
   if SimpleImageSearch("images/firefly/dialogWhite/thereWasAnErrorHandlingYourCurrentActionVM.bmp")
      ClickIfImageSearch("images/firefly/dialog/okButton.bmp")

   Sleep, 100

   if (A_Sec = 0)
      FireflyCheckin("Helper", "Watching")
}

return
;}}}
