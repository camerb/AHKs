#include FcnLib.ahk

;auto-download excel files

SetTitleMatchMode, RegEx
;time:=currentTime()
stopTime:=AddDatetime(currentTime(), 1, "min")
Loop
{
   if ForceWinFocusIfExist("Opening .*.xls ahk_class MozillaDialogClass")
   {
      Click(290, 290, "Control")
   }
   if CurrentlyAfter(stopTime)
      ExitApp
}
