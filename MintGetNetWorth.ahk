#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include MintLogin.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

;hmm... not really using this anymore


while NOT netWorth
{
   mintlogin()

   page:=GhettoUrlDownloadToVar("https://wwws.mint.com/overview.event")
   LongSleep()

   page:=RegExReplace(page, "(`r|`n)", " ")
   RegExMatch(page, "<li class..net-worth.><span class..balance.>..(\d{2}).(\d{3}.\d{2})</span>Net Worth</li>", match)
   netWorth:=match1
}

debug(match1)

;Click(45, 145)
;Send, {PGDN 50}
;MedSleep()
;ClickIfImageSearch("images\mint\exportAllTransactions.bmp")
;ClickIfImageSearch("images\mint\exportAllTransactionsXP.bmp")

;LongSleep()
;if NOT ForceWinFocusIfExist("Save As", "Exact")
   ;Send, {ENTER}
;LongSleep()
;ForceWinFocus("Save As", "Exact")
;date:=CurrentTime("hyphendate")
;csvfilename=C:\My Dropbox\AHKs\gitExempt\mint_export\%date%.csv
;Send, %csvfilename%
;Sleep, 100
;Send, {ENTER}

;close the window
LongSleep()
LongSleep()
LongSleep()
CustomTitleMatchMode("RegEx")
WinClose, Mint.com.*Opera
ExitApp

`:: ExitApp
