#include FcnLib.ahk

TrayMsg2("111")
TrayMsg2("222")
TrayMsg2("333")

TrayMsg2(Title, Text="", TimeInSeconds=20, Icon=1)
{
   ;Was considering making this run in a separate thread so that the script could proceed without having to wait for the quote bubble to close, but that seems like it would be a lot of work, and if several bubbles popped up right in a row they would run one over the other...
   ;TODO perhaps someday i should make the thread pause for two seconds, then display the bubble for the remaining seconds (to allow it to be seen clearly, but to also allow the ahk to keep going)
   ;TODO make the Icon option straight text for readability

   ;if text is blank, the tooltip won't display
   if (Text=="")
   {
      Text:=Title
      Title:=""
   }

   Run, TrayMsg.ahk %Title%
   SleepSeconds(2)
   ;Run, TrayMsg.ahk `"%Title%`" `"%Text%`", %TimeInSeconds%, %Icon%
   ;TrayTip, %Title%, %Text%, %TimeInSeconds%, %Icon%
   ;SleepSeconds(TimeInSeconds)
}
