#include FcnLib.ahk

;time:=currenttime("hyphenated")
;AddToTrace(time)

;email reminder the morning of 8am
;email reminder the day before 10am
;epms timecard reminder

currentDate:=CurrentTime("hyphendate")

dates=2011-11-29,2011-12-13,2011-12-28,2012-01-11,2012-01-30,2012-02-13,2012-02-28,2012-03-13,2012-03-29,2012-04-12,2012-04-27,2012-05-11,2012-05-30,2012-06-13,2012-06-27,2012-07-12,2012-07-30,2012-08-13,2012-08-29,2012-09-12,2012-09-27,2012-10-11,2012-10-30,2012-11-13,2012-11-28,2012-12-12,2012-12-27

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
