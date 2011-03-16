#include FcnLib.ahk

;find out what the amount of slack in the expected transactions is
;assume that this will serve as the maximum credit card bill amount

path=C:\My Dropbox\AHKs\REFP\
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
   {
      credits += reTrans%i%amount
   }
   else
   {
      debits += reTrans%i%amount
   }
}

debug(credits, debits, "", "The projected maximum amount for the credit card bill is", credits-debits)
