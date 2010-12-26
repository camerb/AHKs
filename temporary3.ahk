#include FcnLib.ahk
#include ThirdParty/json.ahk

path=C:\My Dropbox\ahk-REFP\
infile=%path%out1.txt
expectedTransFile=%path%expectedTransactions.txt
projectionCsv=%path%financialProjection.csv
currentMonth=12
currentYear=2010

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
         reTrans%i%=^%currentMonth%%A_LoopField%
      else if (A_Index == 2)
         reTrans%i%title=%A_LoopField%
      else if (A_Index == 3)
         reTrans%i%amount=%A_LoopField%
      else if (A_Index == 4)
         reTrans%i%date=%A_LoopField%
      else if (A_Index == 5)
         reTrans%i%isCredit := %A_LoopField% == "true" ? 1 : 0
   }
}

;Loop, %reTransCount%
      ;debug("here", reTrans%A_Index%)

;Go through the history file
;(check each history against each expected--ij loop)
Loop, Read, %infile%
{
   historyLine=%A_LoopReadLine%
   Loop, %reTransCount%
   {
      i=%A_Index%
      if RegExMatch(historyLine, reTrans%i%)
      {
         ;debug("found it", historyLine)
         ;TODO mark it as found, mark historyTrans as expected?
         reTrans%i%found:=true
      }
   }
}

csvLine := concatWithSep(",", "Date", "Credit", "Debit", "Description", "Balance")
FileAppend, %csvline%, %projectionCsv%

;TODO get current balance
;concatWithSep(",",
;FileAppend, %csvline%, %projectionCsv%

;lets show which transactions we are still expecting (didn't see it yet)
Loop, %reTransCount%
{
   i=%A_Index%
   if (NOT reTrans%i%found)
   {
      debug("didn't find", reTrans%i%)
      ;TODO write to projection csv

      date := concatWithSep("/", currentMonth, reTrans%i%date, currentYear)
      ;csvLine := concatWithSep(",", date,
      FileAppend, %csvline%, %projectionCsv%


   }
}

ExitApp
`:: ExitApp

;myJson(var, key, value="EMPTY")
;{
   ;if (value == "EMPTY")
      ;return json(var, key)
   ;json(var, key, value)
   ;;sucks! there seems to be no nice way to set the element (only change existing elements)
;}
