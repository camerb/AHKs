#include FcnLib.ahk

ForceWinFocus("Mitsi JIRA - Google Chrome", "RegEx")
MouseClick, left,  1214,  302
Sleep, 100
MouseClick, left,  30,  424
Sleep, 100
ForceWinFocus("Close Issue", "RegEx")
MouseClick, left,  618,  242
Sleep, 100
;MouseClick, left,  73,  25
Send, {DOWN}{ENTER}
Sleep, 100
MouseClick, left,  578,  520
Sleep, 100
Send, {CTRLDOWN}v{CTRLUP}
MouseClick, left,  846,  764
Sleep, 100
