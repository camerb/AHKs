#include FcnLib.ahk
#include FcnLib-Opera.ahk
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
   RegExMatch(page, "<li class..net-worth.><span class..balance.>..(\d{2}).(\d{3}.\d{2})</span>Net Worth</li>", match)
   netWorth=-%match1%%match2%
}

usaalogin()

SavingsBalance  := GetAccountInfo("encrypted10bb142d9db5d1209462ee637b61c599")
CheckingBalance := GetAccountInfo("encrypted10bb142d9db5d12081af1bd8872ba833")
CameronBalance  := GetAccountInfo("encryptedb15eff1c50e20965749b3338ceff1d4379e5098d18308caa")
MelindaBalance  := GetAccountInfo("encryptedb15eff1c50e209657b4e04143ceb8bdd5e1587891b30192c")

WinClose
SleepSeconds(2)
Process, Close, opera.exe

overallBalance := SavingsBalance + CheckingBalance - CameronBalance - MelindaBalance
overallBalance := StringTrimRight(overallBalance, 4)

CameronProjection:=GetCreditCardProjection(CameronBalance, 22)
MelindaProjection:=GetCreditCardProjection(MelindaBalance, 12)

;output this stuff to a file
csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, "", overallBalance, "", CameronBalance, CameronProjection, MelindaBalance, MelindaProjection, NetWorth)
FileAppendLine(csvline, csvfile)

;output to ini for easy lookup
IniWrite(ini, "", "FinancesDateUpdated", time)
IniWrite(ini, "", "NetWorth", NetWorth)
IniWrite(ini, "", "SavingsBalance", SavingsBalance)
IniWrite(ini, "", "CheckingBalance", CheckingBalance)
IniWrite(ini, "", "CameronBalance", CameronBalance)
IniWrite(ini, "", "MelindaBalance", MelindaBalance)
IniWrite(ini, "", "OverallBalance", OverallBalance)
IniWrite(ini, "", "CameronProjection", CameronProjection)
IniWrite(ini, "", "MelindaProjection", MelindaProjection)

FileDelete("gitExempt\morning_status\finance.txt")
MorningStatusAppend("Date", time)
MorningStatusAppend("NetWorth", NetWorth)
MorningStatusAppend("Savings", SavingsBalance)
MorningStatusAppend("Checking", CheckingBalance)
MorningStatusAppend("CameronBalance", CameronBalance)
MorningStatusAppend("MelindaBalance", MelindaBalance)
MorningStatusAppend("Overall", OverallBalance)
MorningStatusAppend("CameronProjection", CameronProjection)
MorningStatusAppend("MelindaProjection", MelindaProjection)

ExitApp
;the end of the script

GetAccountInfo(key)
{
   url=https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=%key%&CombinedView=TRUE

   ;ensure returned value is not blank
   ;validating with regex to ensure we have a
   while NOT RegExMatch(returned, "\d+\.\d\d")
   {
      ;force it to change the page, cause the title is the same for all accounts
      GoToPage("http://dl.dropbox.com/u/789954/KnownTitle.html")

      ;get the text of the entire page
      ;debug(url)
      returned:=GhettoUrlDownloadToVar(url)

      ;find the account balance that we are looking for
      returned:=RegExReplace(returned, "(`r|`n)", " ")
      RegExMatch(returned, "<th>(Current Balance).*?(</tr>)", returned)
      RegExMatch(returned, "(\d*,*)*\d+\.\d+", returned)
      returned:=RegExReplace(returned, ",", "")
      ;debug("silent log from getacctinfo", VersionNum(), returned)
   }
   return returned
}

GetCreditCardProjection(currentCreditBalance, endOfBillingCycle)
{
   ;do some math and get the projected CC bill
   FormatTime, currentDay, , dd
   daysThruBillingPeriod := mod( currentDay - endOfBillingCycle + 31, 31 )
   percentThru := daysThruBillingPeriod / 31 * 100
   percentLeft := 100 - percentThru
   spentPerPercent := currentCreditBalance / percentThru
   projectedCreditCardBill := currentCreditBalance + percentLeft * spentPerPercent
   projectedCreditCardBill := StringTrimRight(projectedCreditCardBill, 4)

   ;fix the projection if something odd is going on (like if the bill hasn't been paid yet)
   if (currentDay == endOfBillingCycle)
      projectedCreditCardBill := currentCreditBalance
   if (projectedCreditCardBill > 5000)
      projectedCreditCardBill := currentCreditBalance

   return projectedCreditCardBill
}
