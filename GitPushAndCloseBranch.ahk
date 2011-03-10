#include FcnLib.ahk

;see if we can get the branch name from the file
branchNameFromFile := FileRead("C:\code\epms\.git\HEAD")
RegExMatch(branchNameFromFile, "heads\/(.*)\n", branchName)
branchNameFromFile:=branchName1

;push and close that branch
ForceWinFocus("MINGW32", "Contains")
currentBranchName:=Prompt("What is the name of the current branch?`nPress y if it is: " . branchNameFromFile)
if NOT currentBranchName
   ExitApp

if (currentBranchName = "y")
   currentBranchName:=branchNameFromFile

ForceWinFocus("MINGW32", "Contains")
Send, git status{ENTER}
Send, git push origin %currentBranchName%{ENTER}
Send, git branch -m %currentBranchName% pushed/%currentBranchName%{ENTER}

message=The branch origin/%currentBranchName% is ready to move live
;debug(message)
SendEmail("Branch to merge", message, "", "nathan@mitsi.com", "cameronbaustian@gmail.com")
