#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\Dropbox\AHKs\gitExempt\usaalogin.ahk

mintLogin()
{
   ;Loop
   ;{
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
   ;ClickIfImageSearch("images\mint\LoginButton.bmp")
   ShortSleep()
   Send, {TAB}
   ShortSleep()
   Send, {TAB}
   ShortSleep()
   Send, {ENTER}

   mainPageTitle=Mint.com > Overview - Opera
   CustomTitleMatchMode("Exact")
   WinWaitActive, %mainPageTitle%, , 60
   SleepSeconds(5)

   if (WinGetActiveTitle() == mainPageTitle)
      return
   ;if (count > 5)
      die("when i logged into mint, the title was not as expected", A_ScriptName, A_LineNumber, A_ThisFunc, WinGetActiveTitle())
   count++
   ;}
}
