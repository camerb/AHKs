#include FcnLib.ahk

iniPP(itemTracked)
{
   ;I'm thinking that the section should either be the computer name or the date
   ; for now a combination of the two will keep the sections unique
   ini:=GetPath("MyStats.ini")
   section:=CurrentTime("hyphendate")
   key:=itemTracked

   value := IniRead(ini, section, key)
   value++
   IniWrite(ini, section, key, value)
}

iniMostRecentTime(itemTracked)
{
   ini:=GetPath("MyStats.ini")
   section:=CurrentTime("hyphendate")
   time:=CurrentTime("hyphenated")
   IniWrite(ini, section, itemTracked, time)
}
