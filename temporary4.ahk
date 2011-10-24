#singleinstance off
#include FcnLib.ahk
#singleinstance off

;Run macro once per day

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

;################################################
#include FcnLib.ahk



Loop 10
{
Run temporary4.ahk
;Sleep, 5000
;Sleep, 500
}

RunOncePerDay(ahk, description)
{
   quote="
   description    := EnsureEndsWith(description, quote)
   description    := EnsureStartsWith(description, quote)

   params:=description ;concatWithSep(" ", ahk, description)
   RunAhk("temporary4.ahk", params)
}
