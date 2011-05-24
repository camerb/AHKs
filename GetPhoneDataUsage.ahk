#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

RunOpera()
CloseAllTabs()
MedSleep()
GoToPage("https://www.att.com/olam/loginAction.olamexecute?customerType=W")
joe:=SexPanther("att")
LongSleep()
Send, {TAB 2}972
Send, {TAB}%joe%{ENTER}


