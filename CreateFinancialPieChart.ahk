#include FcnLib.ahk

;this should probably be split into three scripts

;DeleteTraceFile()

date := currenttime("hyphendate")

in =C:\Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-processed.csv
out=C:\Dropbox\AHKs\gitExempt\usaa_export\%date%-credit-graph
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

;DeleteTraceFile()
Loop, read, REFP\credit-categories.txt
{
   category := A_LoopReadLine
   thisLine=%category%`t=SUMIF(G2:G5001`;"=%category%"`;D2:D5001)`r`n
   GraphCells .= thisLine
}
;AddToTrace(GraphCells)

Clipboard := GraphCells
Sleep, 2000
Send, ^v

ForceWinFocus("Text Import")
Sleep, 100
Send, {ENTER}

;Make the graph
ForceWinFocus("OpenOffice")
Send !ia{TAB}{DOWN 2}{TAB 5}{ENTER}
Sleep, 6000
SaveScreenShot("FinancialChart")
Sleep, 6000
Send, ^s!{F4}
