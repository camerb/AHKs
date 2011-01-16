#include FcnLib.ahk

;DeleteTraceFile()

date := currenttime("hyphendate")

in ="C:\My Dropbox\AHKs\gitExempt\mint_export\%date%.csv"
re ="C:\My Dropbox\AHKs\REFP\regex-mint.txt"
out=C:\My Dropbox\AHKs\gitExempt\mint_export\%date%-processed.csv

;REFP(in, re, "`"".out."`"")
;SleepMinutes(1)

;outFileBase=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%
;infile:=out

;Loop, read, %out%
;{
   ;line:=A_LoopReadLine
   ;if InStr(line, "PLATINUM MASTERCARD")
      ;FileAppendLine(line, outFileBase . "-credit.csv")
   ;else if InStr(line, "FOUR STAR CHECKING")
      ;FileAppendLine(line, outFileBase . "-checking.csv")
   ;else if InStr(line, "USAA SAVINGS")
      ;FileAppendLine(line, outFileBase . "-savings.csv")
   ;else if InStr(line, "CHASE PREMIER CHECKING")
      ;FileAppendLine(line, outFileBase . "-chasechecking.csv")
   ;;else
      ;;AddToTrace(line)
;}

;in ="C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit.csv"
;re ="C:\My Dropbox\AHKs\REFP\regex-financial-credit.txt"
out="C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv"
;REFP(in, re, out)

SleepMinutes(2)
;in ="C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking.csv"
;re ="C:\My Dropbox\AHKs\REFP\regex-financial-checking.txt"
out="C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking-processed.csv"
;REFP(in, re, out)

SleepMinutes(2)
Run, scalc.exe %out%

ForceWinFocus("Text Import")
Sleep, 100
Send, {ENTER}
ForceWinFocus("OpenOffice")
Send, {RIGHT 9}


Loop, read, REFP\credit-categories.txt
{
   category := A_LoopReadLine
   ;GraphCells .=

;"hi`thi2`nhi3`thi4`n"

   ;TODO figure out how to put in the correct syntax for getting info for that pie chart
}

Clipboard := GraphCells
Sleep, 2000
Send, ^v
