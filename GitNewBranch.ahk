#include FcnLib.ahk

;make a new branch in git
ForceWinFocus("MINGW32", "Contains")
newBranchName:=Prompt("Give a name for the new branch")
if NOT currentBranchName
   ExitApp

ForceWinFocus("MINGW32", "Contains")
Send, git status{ENTER}
Send, git co -b %newBranchName% origin/release{ENTER}
