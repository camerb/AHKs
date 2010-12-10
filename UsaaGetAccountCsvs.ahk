#include FcnLib.ahk
#include C:\My Dropbox\ahk large files\usaalogin.ahk

C_VersionNum=kids
C_ShortSleep=100
C_MedSleep=2000
C_LongSleep=6000
csvfile=C:\My Dropbox\ahk large files\DailyFinancial.csv
time:=CurrentTime("hyphenated")
date:=CurrentTime("", "slashdate")

usaalogin()

SaveAccountTransactions("savings", time)
SaveAccountTransactions("checking", time)
SaveAccountTransactions("credit", time)

WinClose
Reload

SaveAccountTransactions(account, time)
{
   date:=CurrentTime("", "slashdate")

   Sleep %C_LongSleep%
   csvfilename=C:\My Dropbox\ahk large files\USAA_%Account%_%time%.csv
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
