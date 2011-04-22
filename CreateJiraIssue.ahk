#include FcnLib.ahk
#include ThirdParty\cmdret.ahk

title:=Prompt("Give a title for the JIRA issue")
project:=Prompt("What project is that issue connected to?`n`n" . title)

command=perl C:\code\Examples\JiraClient.pl `"%project%`" `"%title%`"
ret := CmdRet_RunReturn(command)

;if there isn't an exception, don't do a popup... maybe put it in the trace instead?
if NOT RegExMatch(ret, "(exception|atlassian.jira)")
   mode=silent
errord(mode, ret)
