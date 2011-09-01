#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\Dropbox\AHKs\gitExempt\usaalogin.ahk

ini=C:\Dropbox\AHKs\gitExempt\datausage.ini
csvfile=C:\Dropbox\AHKs\gitExempt\datausage.csv
time:=CurrentTime("hyphenated")

while ((NOT CameronDataUsage) OR (NOT NoraDataUsage))
{
   RunOpera()
   CloseAllTabs()
   LongSleep()
   LongSleep()
   GoToPage("https://www.att.com/olam/loginAction.olamexecute?customerType=W")
   joe:=SexPanther("att")
   LongSleep()
   Send, 9723429639
   MedSleep()
   Send, {TAB}
   MedSleep()
   Send, %joe%{ENTER}
   LongSleep()
   LongSleep()

   GoToPage("known")
   page := GhettoUrlDownloadToVar("https://www.att.com/olam/gotoUsageSummary.olamexecute?reportActionEvent=A_UMD_CURRENT_USAGE_SUMMARY")
   page := RemoveLineEndings(page)
   CameronDataUsage := GetDataUsage(page, "CAMERON")
   NoraDataUsage := GetDataUsage(page, "NORA")

   WinClose, ahk_class OperaWindowClass
   SleepSeconds(2)
   ProcessCloseAll("opera.exe")
}

NightlyStats("NoraDataUsage", NoraDataUsage)
NightlyStats("CameronDataUsage", CameronDataUsage)
csvline:=ConcatWithSep(",", time, CameronDataUsage, NoraDataUsage)
FileAppendLine(csvline, csvfile)

ExitApp

GetDataUsage(page, name)
{
   needle=megabytes.*?%name%.*?A_UMD_DATA_DETAILS.*?([0-9]+\.[0-9]+).*?MB.*?of 200.*?MB
   RegExMatch(page, needle, match)
   ;return debug(match1)
   return match1
}

