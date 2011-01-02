#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

mintlogin()

;new development goes here

;close the window
LongSleep()
WinClose

mintLogin()
{
   RunOpera()
   CloseAllTabs()
   LongSleep()

   GoToPage("https://wwws.mint.com/login.event?task=L&messageId=5&country=US")
   ;ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   ;MedSleep()
   ;Send, !d
   ;Sleep, 100
   ;Send, usaa.com{ENTER}
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
   Clipboard:=theTitle
   if (theTitle != "Mint.com > Overview - Opera")
      die("when i logged into mint, the title was not as expected", A_ScriptName, A_LineNumber, A_ThisFunc, theTitle)
}
