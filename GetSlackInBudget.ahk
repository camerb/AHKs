#include FcnLib.ahk
#include C:\Dropbox\AHKs\gitExempt\usaalogin.ahk

;find out what the amount of slack in the expected transactions is
;assume that this will serve as the maximum credit card bill amount

;also figures out a rough estimate of how much we are gaining/losing per month

path=C:\Dropbox\AHKs\gitExempt\
expectedTransFile=%path%expectedTransactions-tpl.txt

;Read in all of the expected transactions
Loop, Read, %expectedTransFile%
{
   i=%A_Index%
   if InStr(A_LoopReadLine, "#debug")
      break
   reTransCount++
   Loop, parse, A_LoopReadLine, CSV
   {
      if (A_Index == 1)
         reTrans%i%=^\"(%currentMonth%|%currentMonthNoZero%)%A_LoopField%
      else if (A_Index == 2)
         reTrans%i%title=%A_LoopField%
      else if (A_Index == 3)
         reTrans%i%amount=%A_LoopField%
      else if (A_Index == 4)
         reTrans%i%date=%A_LoopField%
      else if (A_Index == 5)
         reTrans%i%isCredit := A_LoopField == "true" ? 1 : 0
   }
}

Loop, %reTransCount%
{
   i=%A_Index%
   if (reTrans%i%isCredit)
      credits += reTrans%i%amount
   else
      debits += reTrans%i%amount
}

credits := FormatDollar(credits)
debits  := FormatDollar(debits)

ini=gitExempt/NightlyStats.ini
CameronBalance := IniRead(ini, "MostRecent", "CameronBalance")
MelindaBalance := IniRead(ini, "MostRecent", "MelindaBalance")
CameronProjection:=GetCreditCardProjection(CameronBalance, 22)
MelindaProjection:=GetCreditCardProjection(MelindaBalance, 12)

TotalCreditProjection:=CameronProjection-MelindaProjection

debug("ERRORD NOLOG", credits, debits, CameronProjection, MelindaProjection, TotalCreditProjection)

MaximumCreditBill := Format(credits-debits, "Dollar")
MonthlyDelta := Format(MaximumCreditBill-TotalCreditProjection, "Dollar")
;MaximumCreditBill := FormatDollar(credits-debits)
;MonthlyDelta := FormatDollar(MaximumCreditBill-TotalCreditProjection)

IniWrite(ini, "MostRecent", "MaximumCreditBill", MaximumCreditBill)
IniWrite(ini, "MostRecent", "MonthlyDelta", MonthlyDelta)
MorningStatusAppend("MaximumCreditBill", MaximumCreditBill)
MorningStatusAppend("MonthlyDelta", MonthlyDelta)

debug("ERRORD NOLOG", "The projected maximum amount for the credit card bill is", MaximumCreditBill, "Current projection of monthly change:", MonthlyDelta)

;functions:

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
   if (projectedCreditCardBill > 2000)
      projectedCreditCardBill := currentCreditBalance

   return projectedCreditCardBill
}
