;used to create a new issue in JIRA
;TODO this could be especially useful if I read in the info from an excel file and automate the "import"

WinWait, Create Issue - Mitsi JIRA - Google Chrome,
IfWinNotActive, Create Issue - Mitsi JIRA - Google Chrome, , WinActivate, Create Issue - Mitsi JIRA - Google Chrome,
WinWaitActive, Create Issue - Mitsi JIRA - Google Chrome,
MouseClick, left,  1178,  478
Sleep, 100
MouseClick, left,  496,  452
Sleep, 100
MouseClick, left,  448,  580
Sleep, 100
MouseClick, left,  504,  650
Sleep, 100
MouseClick, left,  432,  362
Sleep, 100
MouseClick, left,  342,  282
Sleep, 100
Send, {PGDN}{PGDN}{PGDN}{PGDN}
MouseClick, left,  742,  962
Sleep, 100

SetTitleMatchMode, RegEx
WinWaitActive, FLB.*Google Chrome
MouseClick, left,  742,  962
Sleep, 100
MouseClick, left,  1482,  138
Sleep, 100
MouseClick, left,  1424,  294
Sleep, 100
WinWait, Create Issue - Mitsi JIRA - Google Chrome,
IfWinNotActive, Create Issue - Mitsi JIRA - Google Chrome, , WinActivate, Create Issue - Mitsi JIRA - Google Chrome,
WinWaitActive, Create Issue - Mitsi JIRA - Google Chrome,
MouseClick, left,  1342,  396
Sleep, 100


;#include FcnLib.ahk
;ForceWinFocus("American Bench.*Google Chrome")
;MouseClick, left,  1203,  210
;Sleep, 100
;MouseClick, left,  1457,  140
;Sleep, 100
;MouseClick, left,  1413,  294
;Sleep, 100
