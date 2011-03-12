#include FcnLib.ahk

TimeToExit:=CurrentTimePlus(20)
while true
{
   if ForceWinFocusIfExist("(Problem loading page|404 Not Found) - Mozilla Firefox ahk_class MozillaUIWindowClass", "RegEx")
   {
      Send, {F5}
      Sleep, 5000
      ;IfWinNotActive, %win%
         ;return
   }

   ;win=Problem loading page - Mozilla Firefox ahk_class MozillaUIWindowClass
   ;IfWinActive, %win%
   ;{
      ;Send, {F5}
      ;Sleep, 5000
      ;IfWinNotActive, %win%
         ;return
   ;}

   IfWinActive, Confirm ahk_class MozillaDialogClass
   {
      Send, {ENTER}
   }

   ;FIXME gosh! why doesn't searching for images in firebug work anymore?
   ClickIfImageSearch("images/firebug/continueButton.bmp")

   Sleep, 100
   if (CurrentlyAfter(TimeToExit))
      exit
}
