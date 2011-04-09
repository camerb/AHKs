#include FcnLib.ahk

;see if we can get the branch name from the file
branchNameFromFile := FileRead("C:\code\epms\.git\HEAD")
RegExMatch(branchNameFromFile, "heads\/(.*)\n", branchName)
branchNameFromFile:=branchName1

RegExMatch(branchNameFromFile, "pushed\/(.*)", branchName)
baseBranchName:=branchName1

if NOT baseBranchName
   ExitApp

ForceWinFocus("MINGW32", "Contains")
Send, git branch -m pushed/%baseBranchName% %baseBranchName%{ENTER}
