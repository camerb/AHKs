#include FcnLib.ahk

;push and close that branch
ForceWinFocus("MINGW32", "Contains")
currentBranchName:=Prompt("What is the name of the current branch?")
if NOT currentBranchName
   ExitApp

ForceWinFocus("MINGW32", "Contains")
Send, git status{ENTER}
Send, git push origin %currentBranchName%{ENTER}
Send, git branch -m %currentBranchName% pushed/%currentBranchName%{ENTER}

message=The branch origin/%currentBranchName% is ready to move live
SendEmail("Branch to merge", message, "", "nathan@mitsi.com", "cameronbaustian@gmail.com")
