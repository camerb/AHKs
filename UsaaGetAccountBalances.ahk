#include FcnLib.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

usaalogin()

SavingsBalance  := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d1209462ee637b61c599&CombinedView=TRUE")
CheckingBalance := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d12081af1bd8872ba833&CombinedView=TRUE")
CreditBalance   := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encryptedb15eff1c50e20965cf67cf785d4589cd0a8a39aafd4160dc&CombinedView=TRUE")

;done with browser click-around, but we have to export to a file, still
WinClose

csvfile=C:\My Dropbox\AHKs\gitExempt\DailyFinancial.csv
time:=CurrentTime("hyphenated")

overallBalance := SavingsBalance + CheckingBalance - CreditBalance
overallBalance := StringTrimRight(overallBalance, 4)
FormatTime, currentDay, , dd
daysThruBillingPeriod := mod( currentDay - 22 + 31, 31 )
percentThru := daysThruBillingPeriod / 31 * 100
percentLeft := 100 - percentThru
spentPerPercent := CreditBalance / percentThru
projectedCreditCardBill := CreditBalance + percentLeft * spentPerPercent
projectedCreditCardBill := StringTrimRight(projectedCreditCardBill, 4)
if (currentDay == 22)
   projectedCreditCardBill := CreditBalance
;debug("silent log green line", currentDay, daysThruBillingPeriod, percentThru, percentLeft, spentPerPercent, projectedCreditCardBill)

csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, CreditBalance, overallBalance, projectedCreditCardBill)
;debug("silent log grey line", csvline)
FileAppendLine(csvline, csvfile)
FileAppendLine(csvline, "gitExempt\morning_status\finance.txt")

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
