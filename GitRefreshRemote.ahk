#include FcnLib.ahk

ForceWinFocus("MINGW32", "Contains")
;Send, git remote prune origin{ENTER}
Send, git fetch origin{ENTER}
Send, git gc{ENTER}
Send, git status{ENTER}
