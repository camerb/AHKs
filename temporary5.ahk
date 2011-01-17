#include FcnLib.ahk

;DeleteTraceFile()

date := currenttime("hyphendate")

;in =C:\My Dropbox\AHKs\gitExempt\mint_export\%date%.csv
;re =C:\My Dropbox\AHKs\REFP\regex-mint.txt
;out=C:\My Dropbox\AHKs\gitExempt\mint_export\%date%-processed.csv

;REFP(in, re, out)
;;ExitApp
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

;in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit.csv
;re =C:\My Dropbox\AHKs\REFP\regex-financial-credit.txt
;out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv
;REFP(in, re, out)

;SleepMinutes(2)
;in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking.csv
;re =C:\My Dropbox\AHKs\REFP\regex-financial-checking.txt
;out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking-processed.csv
;REFP(in, re, out)

;SleepMinutes(2)
out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv
Run, scalc.exe "%out%"

ForceWinFocus("Text Import")
Sleep, 100
Send, {ENTER}
ForceWinFocus("OpenOffice")
Send, {RIGHT 9}

DeleteTraceFile()
Loop, read, REFP\credit-categories.txt
{
   category := A_LoopReadLine
   ;GraphCells .= category . "`n"
   ;GraphCells .= category . "`t" . category . "`n"
   ;GraphCells .= category . "`t=SUMIF(G2:G5001;`"=" . category . "`";D2:D5001)`n"
   thisLine=%category%`t=SUMIF(G2:G5001`;"=%category%"`;D2:D5001)`r`n
   ;=SUMIF(G2:G5001;"=Merchandise";D2:D5001)
   GraphCells .= thisLine

;"hi`thi2`nhi3`thi4`n"

   ;TODO figure out how to put in the correct syntax for getting info for that pie chart
}
AddToTrace(GraphCells)

Clipboard := GraphCells
Sleep, 2000
Send, ^v

ForceWinFocus("Text Import")
Sleep, 100
Send, {ENTER}
