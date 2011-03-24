#include FcnLib.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

csvfile=C:\My Dropbox\AHKs\gitExempt\DailyFinancial.csv
time:=CurrentTime("hyphenated")

usaalogin()

SavingsBalance  := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d1209462ee637b61c599&CombinedView=TRUE")
CheckingBalance := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d12081af1bd8872ba833&CombinedView=TRUE")
CreditBalance   := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encryptedb15eff1c50e20965cf67cf785d4589cd0a8a39aafd4160dc&CombinedView=TRUE")

WinClose

;do some math and get the projected CC bill
overallBalance := SavingsBalance + CheckingBalance - CreditBalance
overallBalance := StringTrimRight(overallBalance, 4)
FormatTime, currentDay, , dd
daysThruBillingPeriod := mod( currentDay - 22 + 31, 31 )
percentThru := daysThruBillingPeriod / 31 * 100
percentLeft := 100 - percentThru
spentPerPercent := CreditBalance / percentThru
projectedCreditCardBill := CreditBalance + percentLeft * spentPerPercent
projectedCreditCardBill := StringTrimRight(projectedCreditCardBill, 4)

;fix the projection if something odd is going on (like if the bill hasn't been paid yet)
if (currentDay == 22)
   projectedCreditCardBill := CreditBalance
if (projectedCreditCardBill > 5000)
   projectedCreditCardBill := CreditBalance

;output this stuff to a file
csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, CreditBalance, overallBalance, projectedCreditCardBill)
FileAppendLine(csvline, csvfile)

MorningStatusAppend("Date", time)
MorningStatusAppend("Savings", SavingsBalance)
MorningStatusAppend("Checking", CheckingBalance)
MorningStatusAppend("Credit", CreditBalance)
MorningStatusAppend("Overall", overallBalance)
MorningStatusAppend("Projected Credit Bill", projectedCreditCardBill)

if (SavingsBalance=="" and CheckingBalance=="" and CreditBalance=="")
   die("login attempt completely unsuccessful", A_ScriptName, A_LineNumber, A_ThisFunc)

ExitApp
;the end of the script

GetAccountInfo(url)
{
   ;force it to change the page, cause the title is the same for all accounts
   GoToPage("http://dl.dropbox.com/u/789954/remotewidget.txt")
   LongSleep()

   ;get the text of the entire page
   ;debug(url)
   returned:=GhettoUrlDownloadToVar(url)

   ;find the account balance that we are looking for
   returned:=RegExReplace(returned, "(`r|`n)", " ")
   RegExMatch(returned, "<th>(Current Balance).*?(</tr>)", returned)
   RegExMatch(returned, "(\d*,*)*\d+\.\d+", returned)
   returned:=RegExReplace(returned, ",", "")
   ;debug("silent log from getacctinfo", VersionNum(), returned)

   return returned
}

MorningStatusAppend(header, item)
{
   text=%header%: %item%
   FileAppendLine(text, "gitExempt\morning_status\finance.txt")
}
