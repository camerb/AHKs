#include FcnLib.ahk

;DeleteTraceFile()

date := currenttime("hyphendate")
;date=2011-01-16
;date=2011-01-18

in =C:\My Dropbox\AHKs\gitExempt\mint_export\%date%.csv
re =C:\My Dropbox\AHKs\REFP\regex-mint.txt
out=C:\My Dropbox\AHKs\gitExempt\mint_export\%date%-processed.csv

REFP(in, re, out)
;ExitApp
SleepMinutes(1)

outFileBase=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%
infile:=out

Loop, read, %out%
{
   line:=A_LoopReadLine
   if InStr(line, "PLATINUM MASTERCARD")
      FileAppendLine(line, outFileBase . "-credit.csv")
   else if InStr(line, "FOUR STAR CHECKING")
      FileAppendLine(line, outFileBase . "-checking.csv")
   else if InStr(line, "USAA SAVINGS")
      FileAppendLine(line, outFileBase . "-savings.csv")
   else if InStr(line, "CHASE PREMIER CHECKING")
      FileAppendLine(line, outFileBase . "-chasechecking.csv")
   ;else
      ;AddToTrace(line)
}

in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit.csv
re =C:\My Dropbox\AHKs\REFP\regex-financial-credit.txt
out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv
REFP(in, re, out)

SleepMinutes(2)
in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking.csv
re =C:\My Dropbox\AHKs\REFP\regex-financial-checking.txt
out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking-processed.csv
REFP(in, re, out)

SleepMinutes(2)
;==============BELOW THIS WORKS
in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv
out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-graph
FileDelete(out . ".xls" )
Run, scalc.exe "%in%"

ForceWinFocus("Text Import")
Sleep, 2000
Send, {ENTER}
ForceWinFocus("OpenOffice")
Sleep, 100
Send, ^+s
ForceWinFocus("Save As")
Sleep, 100
Send, %out%
Send, {TAB}{DOWN 2}{UP 20}m{ENTER}
Send, {TAB}{ENTER}
Sleep, 2000
ForceWinFocus("OpenOffice")
Send, {RIGHT 9}

DeleteTraceFile()
Loop, read, REFP\credit-categories.txt
{
   category := A_LoopReadLine
   thisLine=%category%`t=SUMIF(G2:G5001`;"=%category%"`;D2:D5001)`r`n
   GraphCells .= thisLine
}
AddToTrace(GraphCells)

Clipboard := GraphCells
Sleep, 2000
Send, ^v

ForceWinFocus("Text Import")
Sleep, 100
Send, {ENTER}

;Make the graph
ForceWinFocus("OpenOffice")
Send !ia{TAB}{DOWN 2}{TAB 5}{ENTER}
Sleep, 1000
SaveScreenShot("FinancialChart")
Send, ^s!{F4}
