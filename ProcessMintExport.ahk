#include FcnLib.ahk


date := currenttime("hyphendate")
;date=2011-01-16
;date=2011-01-18

;TODO split into: processMintExport

in =C:\My Dropbox\AHKs\gitExempt\mint_export\%date%.csv
re =C:\My Dropbox\AHKs\REFP\regex-mint.txt
out=C:\My Dropbox\AHKs\gitExempt\mint_export\%date%-processed.csv

if NOT FileExist(in)
   fatalErrord("the infile for creating the pie chart doesn't exist, cannot continue", A_ScriptName)

REFP(in, re, out)
;ExitApp

outFileBase=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%
infile:=out

;TODO split into: separateMintExport
;split into separate files
Loop, read, %infile%
{
   line:=A_LoopReadLine
   if RegExMatch(line, "PLATINUM MASTERCARD.$")
      FileAppendLine(line, outFileBase . "-credit.csv")
   else if RegExMatch(line, "FOUR STAR CHECKING")
      FileAppendLine(line, outFileBase . "-checking.csv")
   else if RegExMatch(line, "USAA SAVINGS")
      FileAppendLine(line, outFileBase . "-savings.csv")
   else if RegExMatch(line, "CHASE PREMIER CHECKING")
      FileAppendLine(line, outFileBase . "-chasechecking.csv")
   ;else
      ;AddToTrace(line)
}

;TODO split into: preProcessForPieChart
;make categories for the pie chart
in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit.csv
re =C:\My Dropbox\AHKs\REFP\regex-financial-credit.txt
out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv
REFP(in, re, out)

in =C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking.csv
re =C:\My Dropbox\AHKs\REFP\regex-financial-checking.txt
out=C:\My Dropbox\AHKs\gitExempt\usaa_export\%date%-checking-processed.csv
REFP(in, re, out)
