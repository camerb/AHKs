#include FcnLib.ahk

;for those times when I need to kill pidgin from home
;ProcessCloseAll("pidgin.exe")
;ExitApp

time:=currenttime("hyphenated")
AddToTrace(time)
joe := 10 / 10
AddToTrace(joe)
joe := 10 // 10
AddToTrace(joe)
ExitApp

;time:=currenttime("hyphenated")
;AddToTrace(time)

;email reminder the morning of 8am
;email reminder the day before 10am
;epms timecard reminder

currentDate:=CurrentTime("hyphendate")

dates=2011-11-29,2011-12-13,2011-12-28
Loop, parse, dates, CSV
{
   thisDate := A_LoopField
   dayBefore := AddDateTime(thisDate, -1, "day") ; . "_00-00-00"
   dayBefore := Format(dayBefore, "hyphendate")
   msg=Timecard is due %thisDate%

   if (currentDate == thisDate AND A_Hour == 08)
      if RunOncePerDay("EpmsTimecardReminder_Today")
         SendEmail("Submit your timecard TODAY", msg, "", "mbaustian@epmsonline.com")

   if (currentDate == dayBefore AND A_Hour == 10)
      if RunOncePerDay("EpmsTimecardReminder_DayBefore")
         SendEmail("Timecard due tomorrow", msg, "", "mbaustian@epmsonline.com")
}

ExitApp


RunOncePerDay(description)
{
   sectionKey:=description

   ini:=GetPath("RunOncePerDay.ini")
   dateKey=date
   currentDate:=CurrentTime("hyphendate")
   lastRunDate:=IniRead(ini, sectionKey, dateKey)

   if (currentDate == lastRunDate)
      return false

   IniWrite(ini, sectionKey, dateKey, currentDate)
   return true
}

#include FcnLib.ahk
SelfDestruct()