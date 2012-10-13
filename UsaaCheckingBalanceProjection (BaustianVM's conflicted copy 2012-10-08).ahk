#include FcnLib.ahk
#include ThirdParty/json.ahk
#include ThirdParty/tf.ahk

;close old windows, if they are still open for some reason
if ForceWinFocusIfExist("out1.*OpenOffice.org", "RegEx")
{
   Sleep, 200
   WinClose
}

A_Quote="
date := currenttime("hyphendate")
path=C:\Dropbox\AHKs\gitExempt\
currentMonth:=CurrentTime("MM")
currentMonthNoZero:=CurrentTime("M")
currentYear:=CurrentTime("yyyy")

infile=%path%usaa_export\%date%-checking.csv
expectedTransFile=%path%expectedTransactions.txt
projectionCsv=%path%financialProjection.csv
;projectionCsv=%path%out1.txt

if NOT FileExist(infile)
   fatalErrord("the infile for creating the financial projection doesn't exist, cannot continue", A_ScriptName)

ini=gitExempt/NightlyStats.ini
CameronProjection := GetMostRecentIniValue("CameronProjection")
MelindaProjection := GetMostRecentIniValue("MelindaProjection")
currentCheckingBalance := GetMostRecentIniValue("CheckingBalance")

;put this in the expected file using an REFP
expectedTransTpl=%path%expectedTransactions-tpl.txt
FileCopy(expectedTransTpl, expectedTransFile, "overwrite")
TF_Replace("!"expectedTransFile, "ZZZccCameronPaymentEstimateZZZ", CameronProjection)
TF_Replace("!"expectedTransFile, "ZZZccMelindaPaymentEstimateZZZ", MelindaProjection)

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

;Go through the history file
;(check each history against each expected--ij loop)
Loop, Read, %infile%
{
   historyLine=%A_LoopReadLine%
      ;AddToTrace(historyLine)
   Loop, %reTransCount%
   {
      i=%A_Index%
      if RegExMatch(historyLine, reTrans%i%)
      {
         ;debug("found it", historyLine)
         ;TODO mark historyTrans as expected?
         reTrans%i%found:=true
      }
      ;debug(reTrans%i%, "", historyLine)
   }
}

;start the financial projection file
createdDate=Created On %date%
csvLine := concatWithSep(",", "Date", "Credit", "Debit", "Description", "Balance", createdDate)
FileDelete(projectionCsv)
FileAppendLine(csvline, projectionCsv)
currentCheckingBalanceLine := "1999-12-12,,,," . currentCheckingBalance
FileAppendLine(currentCheckingBalanceLine, projectionCsv)
linecount=1

;lets show which transactions we are still expecting (didn't see it yet)
Loop, %reTransCount%
{
   i=%A_Index%
   if (NOT reTrans%i%found)
   {
      ;debug("didn't find", reTrans%i%)
      ;TODO write to projection csv

      date := concatWithSep("-", currentYear, currentMonth, reTrans%i%date)
      creditCell :=     reTrans%i%isCredit ? reTrans%i%amount : ""
      debitCell  := NOT reTrans%i%isCredit ? reTrans%i%amount : ""
      reasonCell := a_quote . reTrans%i%title . a_quote
      plusone:=linecount+1
      plustwo:=plusone+1
      balanceCell==E%plusone%-C%plustwo%+B%plustwo%
      csvLine := concatWithSep(",", date, creditCell, debitCell, reasonCell, balanceCell)
      FileAppendLine(csvline, projectionCsv)
      linecount++
   }
}

;TODO save to a var instead, then sort it
;TODO put all this common code with the date computation and stuff into a function
;TODO make the datemath real and use a std timestamp, then print it in the var as hyphendate
;TODO deal with printing the equation column when it is printed to the file (so it doesn't get messed up in the sort)
;TODO add in the expected transactions that are not monthly (one-time, yearly)

;lets add 5 more months on there (originally this was 2 more)
Loop 6
{
   currentMonth := ZeroPad(++currentMonth, 2)
   Loop, %reTransCount%
   {
      i=%A_Index%
      date := concatWithSep("-", currentYear, currentMonth, reTrans%i%date)
      creditCell :=     reTrans%i%isCredit ? reTrans%i%amount : ""
      debitCell  := NOT reTrans%i%isCredit ? reTrans%i%amount : ""
      reasonCell := a_quote . reTrans%i%title . a_quote
      plusone:=linecount+1
      plustwo:=plusone+1
      balanceCell==E%plusone%-C%plustwo%+B%plustwo%
      csvLine := concatWithSep(",", date, creditCell, debitCell, reasonCell, balanceCell)
      FileAppendLine(csvline, projectionCsv)
      linecount++
   }
}

;remove the generated file to reduce confusion
FileDelete(expectedTransFile)

ExitApp

;TODO use SnapDB to view this
;TODO only view when no params have been passed in (debugMode -- whenever we run it from FARR)

Run, scalc.exe "%projectionCsv%"
ForceWinFocus("Text Import")
;Sleep, 2000
Sleep, 200
;Send, {TAB 2}c
Send, {ENTER}
ForceWinFocus("OpenOffice")

ExitApp
`:: ExitApp

GetMostRecentIniValue(key)
{
   ini:=getPath("NightlyStats.ini")
   returned=ERROR
   date := currenttime("hyphendate")
   while (returned == "ERROR")
   {
      returned := IniRead(ini, date, key)
      date := AddDatetime(date, -1, "day")
      date := Format(date, "hyphendate")
   }
   return returned
}
