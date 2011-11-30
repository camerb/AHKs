#include FcnLib.ahk

KillPidgin() ;for those times when I need to kill pidgin from home

addtotrace("started")
testDates=2011-11-15,2011-11-16,2011-11-17,2011-11-18,2011-11-19,2011-11-20,2011-11-21,2011-11-22,2011-11-23,2011-11-24,2011-11-25,2011-11-26,2011-11-27,2011-11-28,2011-11-29,2011-11-30,2011-12-01,2011-12-02,2011-12-03,2011-12-04,2011-12-05,2011-12-06,2011-12-07,2011-12-08,2011-12-09,2011-12-10,2011-12-11,2011-12-12,2011-12-13,2011-12-14,2011-12-15,2011-12-16,2011-12-17,2011-12-18,2011-12-19,2011-12-20,2011-12-21,2011-12-22,2011-12-23,2011-12-24,2011-12-25,2011-12-26,2011-12-27,2011-12-28,2011-12-29,2011-12-30,2011-12-31
Loop, parse, testDates, CSV
   TimecardReminder(A_LoopField)
ExitApp

TimecardReminder(param)
{

currentDate:=CurrentTime("hyphendate")
currentDate:=param  ;REMOVEME

;email reminder the morning of 8am
;email reminder the day before 10am
;epms timecard reminder
dates=2011-11-29,2011-12-13,2011-12-28
Loop, parse, dates, CSV
{
   thisDate := A_LoopField
   dayBefore := AddDateTime(thisDate, -1, "day") ; . "_00-00-00"
   dayBefore := Format(dayBefore, "hyphendate")
   msg=Timecard is due %thisDate%

   if (currentDate == thisDate AND A_Hour == 08)
      if RunOncePerDay("EpmsTimecardReminder_Today")
         addtotrace("joe")
         ;SendEmail("Submit your timecard TODAY", msg, "", "mbaustian@epmsonline.com")

   if (currentDate == dayBefore AND A_Hour == 10)
      if RunOncePerDay("EpmsTimecardReminder_DayBefore")
         addtotrace("jane")
         ;SendEmail("Timecard due tomorrow", msg, "", "mbaustian@epmsonline.com")
}
}

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

KillPidgin()
{
time:=currenttime("hyphenated")
AddToTrace(time, "killed pidgin", A_ComputerName)
ProcessCloseAll("pidgin.exe")
ExitApp
}

#include FcnLib.ahk
SelfDestruct()