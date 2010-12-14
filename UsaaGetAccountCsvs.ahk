#include FcnLib.ahk
#include C:\My Dropbox\AHKs-GitExempt\usaalogin.ahk

usaalogin()

time:=CurrentTime("hyphenated")
date:=CurrentTime("", "slashdate")

SaveAccountTransactions("savings", time)
SaveAccountTransactions("checking", time)
SaveAccountTransactions("credit", time)

;run refp for checking and savings

ForceWinFocus("Opera")
WinClose
;end of the script

SaveAccountTransactions(account, time)
{
   date:=CurrentTime("", "slashdate")

   LongSleep()
   csvfilename=C:\My Dropbox\AHKs-GitExempt\usaa_export\usaa_%Account%_%time%.csv
   GoToPage( UsaaUrl(account) )

   ForceWinFocus("USAA / My Accounts / Account Summary - Opera")
   LongSleep()
   ClickIfImageSearch("images/usaa/exportTab.bmp")
   MedSleep()
   Send, {TAB}
   MedSleep()
   Send, {RIGHT}
   MedSleep()
   Send, {RIGHT}
   MedSleep()
   Send, {TAB}
   MedSleep()
   SendRaw, 10/10/1979
   MedSleep()
   Send, {TAB 2}
   MedSleep()
   SendRaw, %date%
   MedSleep()
   Send, {TAB 2}
   Send, {DOWN 2}

   ;click on export button
   ClickIfImageSearch("images/usaa/GreenButton.bmp")
   LongSleep()
   Click
   Click
   ShortSleep()
   Click
   Click
   ShortSleep()
   Click
   Click

   ForceWinFocus("Save As", "Exact")
   Send, %csvfilename%
   Sleep, 100
   Send, {ENTER}
}
