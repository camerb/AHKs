#include FcnLib.ahk

ForceWinFocus("GVIM", "Contains")
Send, {ESC 6}{;}wa{ENTER}
timestamp := CurrentTime()
FileCopy, temporary8.ahk, C:\Dropbox\AHKs\scheduled\PHOSPHORUS\%timestamp%.ahk, 1

;confirm that we just ran the right script
Send, {;}Bueller...
SleepSeconds(2)
Send, {ESC 6}
