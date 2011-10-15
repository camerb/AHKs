#singleinstance off
#include FcnLib.ahk
#singleinstance off

;params
scriptToRun=joe.ahk
key=testing

sectionKey:=A_ScriptName . " " . key

ini:=GetPath("RunOncePerDay.ini")
dateKey=date
currentDate:=CurrentTime("hyphendate")
lastRunDate:=IniRead(ini, sectionKey, dateKey)

if (currentDate == lastRunDate)
   ExitApp

IniWrite(ini, sectionKey, dateKey, currentDate)
;TODO change this over before deploy
;RunAhk(scriptToRun)
debug("Ran Script...")
