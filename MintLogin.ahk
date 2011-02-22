#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

mintLogin()
{
   RunOpera()
   CloseAllTabs()
   MedSleep()

   GoToPage("https://wwws.mint.com/login.event")
   LongSleep()

   joe:=SexPanther()
   Send, cameronbaustian@gmail.com
   ShortSleep()
   Send, {TAB}
   ShortSleep()
   Send, %joe%
   ShortSleep()
   ClickIfImageSearch("images\mint\LoginButton.bmp")

   LongSleep()
   theTitle := WinGetActiveTitle()
   if (theTitle != "Mint.com > Overview - Opera")
      die("when i logged into mint, the title was not as expected", A_ScriptName, A_LineNumber, A_ThisFunc, theTitle)
}
