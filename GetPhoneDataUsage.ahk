#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

RunOpera()
CloseAllTabs()
MedSleep()
GoToPage("https://www.att.com/olam/loginAction.olamexecute?customerType=W")
joe:=SexPanther("att")
LongSleep()
Send, {TAB 2}9723429639
Send, {TAB}%joe%{ENTER}
LongSleep()
LongSleep()

https://www.att.com/olam/gotoUsageSummary.olamexecute?reportActionEvent=A_UMD_CURRENT_USAGE_SUMMARY
