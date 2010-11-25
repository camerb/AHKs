
;################## lame attempt at converting a xls to csv
workingDir = C:\Users\VMEP\Documents\Projects\Timesheet\test\
fileIn = testcsvinput.csv
fileOut = testxlsoutput.xls
pathIn = %workingDir%%fileIn%
pathOut = %workingDir%%fileOut%
;while WinExist OpenOffice.org Calc
{
	WinClose OpenOffice.org Calc
	Sleep 1000
}
Run, C:\Program Files\OpenOffice.org 3\program\scalc.exe
IfExist %filenameout%
	FileDelete %filenameout%
WinWait, Untitled 1 - OpenOffice.org Calc, 
IfWinNotActive, Untitled 1 - OpenOffice.org Calc, , WinActivate, Untitled 1 - OpenOffice.org Calc, 
WinWaitActive, Untitled 1 - OpenOffice.org Calc, 
Send, {CTRLDOWN}o{CTRLUP}
WinWait, Open, 
IfWinNotActive, Open, , WinActivate, Open, 
WinWaitActive, Open, 
Send, %filenamein%
Send, {ENTER}
WinWait, Text Import - [
IfWinNotActive, Text Import - [
WinActivate, Text Import - [
WinWaitActive, Text Import - [
Send, {ENTER}
WinWait OpenOffice.org Calc
IfWinNotActive OpenOffice.org Calc
WinActivate OpenOffice.org Calc
WinWaitActive OpenOffice.org Calc
Send, {CTRLDOWN}{SHIFTDOWN}s{SHIFTUP}{CTRLUP}
WinWait, Save As, 
IfWinNotActive, Save As, , WinActivate, Save As, 
WinWaitActive, Save As, 
MouseClick, left,  592,  180
Sleep, 100
MouseClick, left,  587,  409
Sleep, 100
Send, {UP}{UP}{UP}{UP}{UP}{UP}{UP}{UP}{UP}{UP}{UP}{UP}{UP}{ENTER}
MouseClick, left,  262,  383
Sleep, 100
Send, %filenameout%
Send, {TAB}{TAB}{TAB}{TAB}{ENTER}
WinWait OpenOffice.org Calc
IfWinNotActive OpenOffice.org Calc
WinActivate OpenOffice.org Calc
WinWaitActive OpenOffice.org Calc
Send, {CTRLDOWN}{F4}{F4}{CTRLUP}
return