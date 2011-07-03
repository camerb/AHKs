#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

ini=C:\My Dropbox\AHKs\gitExempt\datausage.ini
csvfile=C:\My Dropbox\AHKs\gitExempt\datausage.csv
time:=CurrentTime("hyphenated")

RunOpera()
CloseAllTabs()
LongSleep()
LongSleep()
GoToPage("https://www.att.com/olam/loginAction.olamexecute?customerType=W")
joe:=SexPanther("att")
LongSleep()
Send, 9723429639
Send, {TAB}%joe%{ENTER}
LongSleep()
LongSleep()

GoToPage("known")
page := GhettoUrlDownloadToVar("https://www.att.com/olam/gotoUsageSummary.olamexecute?reportActionEvent=A_UMD_CURRENT_USAGE_SUMMARY")
page := RemoveLineEndings(page)
CameronDataUsage := GetDataUsage(page, "CAMERON")
NoraDataUsage := GetDataUsage(page, "NORA")

;ReportNightlyStats(NoraDataUsage, heading, csvFile, varNameForIni)
;ReportNightlyStats(CameronDataUsage, heading, csvFile, varNameForIni)
csvline:=ConcatWithSep(",", time, CameronDataUsage, NoraDataUsage)
FileAppendLine(csvline, csvfile)

GetDataUsage(page, name)
{
   needle=megabytes.*?%name%.*?A_UMD_DATA_DETAILS.*?([0-9]+\.[0-9]+).*?MB.*?of 200.*?MB
   RegExMatch(page, needle, match)
   return match1
}

