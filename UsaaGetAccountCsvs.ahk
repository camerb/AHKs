#include FcnLib.ahk
#include C:\Dropbox\AHKs\gitExempt\usaalogin.ahk

usaalogin()

time:=CurrentTime("hyphenated")
date:=CurrentTime("slashdate")

SaveAccountTransactions("savings", time)
SaveAccountTransactions("checking", time)
SaveAccountTransactions("credit", time)

;run refp for checking and savings

ForceWinFocus("Opera")
WinClose
;end of the script
ExitApp

SaveAccountTransactions(account, time)
{
   date:=CurrentTime("slashdate")

   LongSleep()
   csvfilename=C:\Dropbox\AHKs\gitExempt\usaa_export\usaa_%Account%_%time%.csv
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
   MedSleep()
   Send, {DOWN 2}
   MedSleep()

   ;click on export button
         ;if NOT ClickIfImageSearch("images/usaa/GreenButton2.bmp")
   if NOT ClickIfImageSearch("images/usaa/ExportButton.bmp")
      if NOT ClickIfImageSearch("images/usaa/GreenButton.bmp")
         die("hmm, didn't see a green button", A_ScriptName, A_LineNumber, A_ThisFunc)

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
