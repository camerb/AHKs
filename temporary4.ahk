#singleinstance off
#include FcnLib.ahk
#singleinstance off

;Run macro once per day

Loop 10
{
RunOncePerDay("temporary4.ahk", "testing")
;Sleep, 5000
Sleep, 500
}


RunOncePerDay(ahk, description)
{
;params
scriptToRun=joe.ahk
key=testing

   sectionKey:=scriptToRun . " " . key

   ini:=GetPath("RunOncePerDay.ini")
   dateKey=date
   currentDate:=CurrentTime("hyphendate")
   lastRunDate:=IniRead(ini, sectionKey, dateKey)

   if (currentDate == lastRunDate)
      return

   IniWrite(ini, sectionKey, dateKey, currentDate)
   ;TODO change this over before deploy
   ;RunAhk(scriptToRun)
   debug("Ran Script...")

   quote="
   description    := EnsureEndsWith(description, quote)
   description    := EnsureStartsWith(description, quote)

   params:=description ;concatWithSep(" ", ahk, description)
   ;RunAhk("temporary4.ahk", params)
   debug("ran the script")
}

SetOneGlobal(variableName, value)
{
   global
   %variableName% := value
}

GetOneGlobal(variableName)
{
   global
   value := %variableName%
   return value
}
