#include FcnLib.ahk
#include ThirdParty\cmdret.ahk

;debug(CmdRet_RunReturn("ping google.com"))

title:=Prompt("Give a title for the JIRA issue")
project:=Prompt("What project is that issue connected to?`n`n" . title)

var=perl C:\code\Examples\JiraClient.pl `"%project%`" `"%title%`"
;debug(CmdRet_RunReturn("perl C:\code\Examples\JiraClient.pl `"FLB`" `"Testing JIRA`:`:Client`""))
debug("", CmdRet_RunReturn(var))
