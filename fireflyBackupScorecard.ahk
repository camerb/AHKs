#include FcnLib.ahk
#include Firefly-FcnLib.ahk
;save and archive the scorecard, if possible

AssignGlobals()

fatalIfNotThisPc("BAUSTIAN12")

iniPP("Started Firefly Backup Scorecard")

;TODO maybe move this back into the other macro, if I can find a good place for it
;   and if I can get the archiving to work fine
;we just want to save the file sometimes
ExcelTitle := WinGetActiveTitle()
timestamp := CurrentTime("hyphenated")
datestamp := CurrentTime("hyphendate")

;trigger a save on excel when it is in the background
Sleep, 500
WinWaitActive, %firefox%
ControlSend, , ^s, %excel%
;ControlSend, , {CTRL DOWN}s{CTRL UP}, %excel%
;ForceWinFocus(excel)
;Send, ^s
;ForceWinFocus(firefox)
Sleep, 500

RegExMatch(ExcelTitle, ".*\.xls", ExcelFile)
WorkingExcelFile=C:\Dropbox\Melinda\Firefly\%ExcelFile%
ArchivedExcelFile=C:\Dropbox\Melinda\Firefly\archive-scorecards\%datestamp%\ProcessServerScorecard-%timestamp%.xls
if NOT FileExist(WorkingExcelFile)
{
   errord("silent", "(error 34) Had trouble finding the scorecard file after it was saved.", WorkingExcelFile, ArchivedExcelFile)
   ExitApp
   ;return
}
myConfig := GetPath("MyConfig.ini")
IniWrite(myConfig, "FireflyScorecard", "WorkingExcelFile", WorkingExcelFile)

Sleep, 25000

;FileCopy(WorkingExcelFile, ArchivedExcelFile)
ExitApp
