#include FcnLib.ahk

;close jira issue and log work

issueNum:=Prompt("What is the jira issue that you want to close?")
timeSpent:=Prompt("How much time was spent on this issue?")

ForceWinFocus("JIRA - Google Chrome", "Contains")
Sleep, 100
Send, !d
Send, jira.mitsi.com/browse/%issueNum%{ENTER}
;MouseClick, left,  191,  881
Sleep, 100
Send, .log{ENTER}
Sleep, 100
Send, %timeSpent%{ENTER}
Sleep, 100
Send, .close{ENTER}
MouseClick, left,  1195,  776
;Sleep, 100

ExitApp
ESC::ExitApp
`::ExitApp

ss()
{
Sleep, 100
}
