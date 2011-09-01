#include FcnLib.ahk
#include thirdParty/COM.ahk
#include C:\Dropbox\AHKs\gitExempt\usaalogin.ahk

SetBatchLines, 300ms

;Awesome use of COM to log in to usaa

ini=C:\Dropbox\AHKs\gitExempt\financial.ini
csvfile=C:\Dropbox\AHKs\gitExempt\DailyFinancial.csv
;time:=CurrentTime("hyphenated")

RunIECOM()
UsaaLoginCOM()

SavingsBalance  := GetAccountInfoCOM("encrypted10bb142d9db5d1209462ee637b61c599")
CheckingBalance := GetAccountInfoCOM("encrypted10bb142d9db5d12081af1bd8872ba833")
CameronBalance  := GetAccountInfoCOM("encryptedb15eff1c50e20965749b3338ceff1d4379e5098d18308caa")
MelindaBalance  := GetAccountInfoCOM("encryptedb15eff1c50e209657b4e04143ceb8bdd5e1587891b30192c")

COM_Invoke(pwb, "Quit")
COM_Term()

overallBalance := SavingsBalance + CheckingBalance - CameronBalance - MelindaBalance
overallBalance := FormatDollar(overallBalance)

CameronProjection:=GetCreditCardProjection(CameronBalance, 22)
MelindaProjection:=GetCreditCardProjection(MelindaBalance, 12)

;output this stuff to a file
csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, "", overallBalance, "", CameronBalance, CameronProjection, MelindaBalance, MelindaProjection, NetWorth)
FileAppendLine(csvline, csvfile)

;prep morning status file
FileDelete("gitExempt\morning_status\finance.txt")

NightlyStats("SavingsBalance",    SavingsBalance)
NightlyStats("CheckingBalance",   CheckingBalance)
NightlyStats("CameronBalance",    CameronBalance)
NightlyStats("MelindaBalance",    MelindaBalance)
NightlyStats("OverallBalance",    OverallBalance)
NightlyStats("CameronProjection", CameronProjection)
NightlyStats("MelindaProjection", MelindaProjection)
NightlyStats("SuccessfulRun", CurrentTime("hyphenated"))

ExitApp
;the end of the script

GetAccountInfoCOM(key)
{
   global pwb
   url=https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=%key%&CombinedView=TRUE

   ;ensure returned value is not blank
   ;validating with regex to ensure we have a value
   while NOT RegExMatch(returned, "\d+\.\d\d")
   {
      returned := GetPageSource(url)

      ;find the account balance that we are looking for
      returned:=RegExReplace(returned, "(`r|`n)", " ")
      RegExMatch(returned, "<TH>(Current Balance).*?(</TR>)", returned)
      returned:=FormatDollar(returned)
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
