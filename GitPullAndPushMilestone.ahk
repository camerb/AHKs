#include FcnLib.ahk
#include FcnLib-Misc.ahk

;not sure if i actually want to do this... the pull/push should be done rarely

;see if we can get the branch name from the file
branchName := GitGetCurrentBranchName()

;preview the status
ForceWinFocus("MINGW32", "Contains")
SendInput, clear{ENTER}
SendInput, git status{ENTER}

if NOT RegExMatch(branchName, "^milestone")
   fatalErrord(branchname, "it looks like this branch is not a milestone branch")

;push and close that branch
decision:=Prompt("Do you actually want to Pull and Push?`nPress n if the status is not clean (observe the git window now)`nPress y if you do")
if (decision <> "y")
   ExitApp

ForceWinFocus("MINGW32", "Contains")
SendInput, git pull origin %branchName%{ENTER}
Sleep, 100
SendInput, git push origin %branchName%{ENTER}

