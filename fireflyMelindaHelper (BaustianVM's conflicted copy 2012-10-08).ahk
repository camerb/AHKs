#include firefly-FcnLib.ahk
#singleinstance force

;This script helps us deal with those things/errors that could pop up at any time and are annoying to Mel

AssignGlobals()
FireflyCheckin("MelindaHelper", "Started")
;AddToTrace("faint green line - started melinda helper")

;{{{Persistent items (things that are checked repetitively)
;Loop 5000
Loop 1000
{
   if ForceWinFocusIfExist(statusProMessage)
   {
      ;if SimpleImageSearch("images/firefly/dialogWhite/thereWasAnErrorHandlingYourCurrentActionVM.bmp")
         ;ClickIfImageSearch("images/firefly/dialog/okButton.bmp")
      if SimpleImageSearch("images/firefly/dialog/pleaseSelectAnOptionFromTheDropDown.bmp")
         Click(170, 90, "control") ;center ok button
      if SimpleImageSearch("images/firefly/dialog/selectedFeesEntryHasBeenDeletedSuccessfully.bmp")
         Click(170, 90, "control") ;center ok button
      if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
      {
         Click(170, 90, "control") ;center ok button
         ;AddToTrace("xxxxxxxx - saw firefly generic ui error")
      }
   }

   ;IfWinExist, fireflyButtons.ahk, open clipboard for reading
   ;{
      ;addToTrace("yellow line - saw 'cant open clipboard for reading' error")
      ;problematicHWND := DllCall("GetClipboardOwner")
      ;WinGetTitle, problematicTitle, ahk_id %problematicHWND%
      ;debug("silent yellow line", "saw 'cant open clipboard for reading' error", problematicHWND, problematicTitle)
      ;Sleep, 30000
   ;}

   Sleep, 10
   ;Sleep, 100

   ;checkin
   if (A_Sec = 0)
   {
      FireflyCheckin("MelindaHelper", "Watching (0 sec)")
   }
}
Reload()

return
;}}}
