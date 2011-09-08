#include FcnLib.ahk

;TODO we should probably just put everything in the mint path and we should probably make it global
path=C:\Dropbox\AHKs\gitExempt\usaa_export\
mintpath=C:\Dropbox\AHKs\gitExempt\mint_export\
date := currenttime("hyphendate")

;fix debit vs credit (use minus sign)
in =%mintpath%%date%.csv
re =C:\Dropbox\AHKs\REFP\regex-mint.txt
out=%mintpath%%date%-processed.csv

if NOT FileExist(in)
   fatalErrord("the infile for creating the pie chart doesn't exist, cannot continue", A_ScriptName)

REFP(in, re, out)

outFileBase=%path%%date%
infile:=out

;split into separate files
Loop, read, %infile%
{
   line:=A_LoopReadLine
   if RegExMatch(line, "PLATINUM MASTERCARD.$")
      FileAppendLine(line, outFileBase . "-credit.csv")
   else if RegExMatch(line, "CAMERON MASTERCARD.$")
      FileAppendLine(line, outFileBase . "-cameroncredit.csv")
   else if RegExMatch(line, "MELINDA MASTERCARD.$")
      FileAppendLine(line, outFileBase . "-melindacredit.csv")
   else if RegExMatch(line, "FOUR STAR CHECKING")
      FileAppendLine(line, outFileBase . "-checking.csv")
   else if RegExMatch(line, "USAA SAVINGS")
      FileAppendLine(line, outFileBase . "-savings.csv")
   else if RegExMatch(line, "CHASE PREMIER CHECKING")
      FileAppendLine(line, outFileBase . "-chasechecking.csv")
   else if RegExMatch(line, "ROUTINE CREDIT CARD")
      FileAppendLine(line, outFileBase . "-routinecredit.csv")
   else
   {
      nonMatchCount++
      ;AddToTrace(line)
   }
}

if (nonMatchCount > 1)
   errord("orange line", "looks like there are multiple records that do not correspond to an account, you should remedy this soon to keep your financial projections accurate", A_ScriptName, A_LineNumber)

;make categories for the pie chart
;in =%path%%date%-credit.csv
;re =C:\Dropbox\AHKs\REFP\regex-financial-credit.txt
;out=%path%%date%-credit-processed.csv
;REFP(in, re, out)

in =%path%%date%-checking.csv
re =C:\Dropbox\AHKs\REFP\regex-financial-checking.txt
out=%path%%date%-checking-processed.csv
REFP(in, re, out)


