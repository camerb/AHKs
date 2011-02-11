#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

mintlogin()

GoToPage("https://wwws.mint.com/transaction.event")
LongSleep()

Click(45, 145)
Send, {PGDN 50}
MedSleep()
ClickIfImageSearch("images\mint\exportAllTransactions.bmp")
ClickIfImageSearch("images\mint\exportAllTransactionsXP.bmp")

LongSleep()
if NOT ForceWinFocusIfExist("Save As", "Exact")
   Send, {ENTER}
LongSleep()
ForceWinFocus("Save As", "Exact")
date:=CurrentTime("hyphendate")
csvfilename=C:\My Dropbox\AHKs\gitExempt\mint_export\%date%.csv
Send, %csvfilename%
Sleep, 100
Send, {ENTER}

;close the window
LongSleep()
LongSleep()
LongSleep()
CustomTitleMatchMode("RegEx")
WinClose, Mint.com.*Opera
ExitApp

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

   MedSleep()
   theTitle := WinGetActiveTitle()
   if (theTitle != "Mint.com > Overview - Opera")
      die("when i logged into mint, the title was not as expected", A_ScriptName, A_LineNumber, A_ThisFunc, theTitle)
}

`:: ExitApp
