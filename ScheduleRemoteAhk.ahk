#include FcnLib.ahk

time:=CurrentTime()
fileContents:=Prompt("Enter the text of your ahk here:")
computerName:=Prompt("What computer do you want to schedule this ahk for?")

ScheduleRemoteAhk(fileContents, computerName)

;filename=C:\Dropbox\AHKs\scheduled\%computerName%\%time%.ahk
;FileCopy, C:\Dropbox\AHKs\template.ahk, %filename%, 1
;fileContents:=StringReplace(fileContents, "``n", "`n")

;FileAppend, %fileContents%, %filename%
