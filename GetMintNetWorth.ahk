#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include FcnLib-Misc.ahk
#include MintLogin.ahk
#include C:\Dropbox\AHKs\gitExempt\usaalogin.ahk

ini=C:\Dropbox\AHKs\gitExempt\financial.ini
csvfile=C:\Dropbox\AHKs\gitExempt\DailyFinancial.csv
time:=CurrentTime("hyphenated")

;get mint net worth
while NOT NetWorth
{
   mintlogin()

   GoToPage("http://dl.dropbox.com/u/789954/KnownTitle.html")
   page:=GhettoUrlDownloadToVar("https://wwws.mint.com/overview.event")
   LongSleep()

   page:=RegExReplace(page, "(`r|`n)", " ")
   RegExMatch(page, "<li class..net-worth.><span class..balance.>..(\d{1,2,3}).(\d{3}.\d{2})</span>Net Worth</li>", match)
   netWorth=-%match1%%match2%
}

WinClose
SleepSeconds(2)
ProcessCloseAll("opera.exe")

NightlyStats("NetWorth", NetWorth)

ExitApp
;the end of the script
