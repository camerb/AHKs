#include FcnLib.ahk

;not sure if i actually want to do this... the pull/push should be done rarely

;see if we can get the branch name from the file
branchNameFromFile := FileRead("C:\code\epms\.git\HEAD")
RegExMatch(branchNameFromFile, "heads\/(.*)\n", branchName)
branchNameFromFile:=branchName1

;preview the status
ForceWinFocus("MINGW32", "Contains")
Send, git status{ENTER}

;push and close that branch
decision:=Prompt("Do you actually want to Pull and Push?`nPress n if the status is not clean (observe the git window now)`nPress y if you do")
if (decision <> "y")
   ExitApp

if (branchNameFromFile = "milestone/customer-survey-reporting")
   currentBranchName:=branchNameFromFile

ForceWinFocus("MINGW32", "Contains")
Send, git pull origin %currentBranchName%{ENTER}
Sleep, 500
Send, git push origin %currentBranchName%{ENTER}

