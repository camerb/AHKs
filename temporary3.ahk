#include FcnLib.ahk

ForceWinFocus("JIRA - Google Chrome", "Contains")
Send, !d

Send, jira.mitsi.com/browse/EPMS-2213{ENTER}
MouseClick, left,  191,  881
Sleep, 100
Send, .log{ENTER}
Send, 3h{ENTER}
Send, .close{ENTER}
MouseClick, left,  1195,  776
Sleep, 100

ExitApp
ESC::ExitApp
`::ExitApp

ss()
{
Sleep, 100
}
