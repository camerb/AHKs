#include FcnLib.ahk
#include FcnLib-Misc.ahk
#include ThirdParty/CmdRet.ahk

currentBranchName := GitGetCurrentBranchName()
issueNumber := GitGetIssueNumber(currentBranchName)

command=perl C:\code\mtsi-scripts\jira-issue-title.pl %issueNumber%
issueTitle := CmdRet_RunReturn( command )

ForceWinFocus("MINGW32", "Contains")
Send, git status{ENTER}

newBranchName := Prompt("What would you like the new name of the branch to be? The current branch seems to refer to this issue:`n`n" . issueTitle)

ForceWinFocus("MINGW32", "Contains")
Send, git branch -m %currentBranchName% %newBranchName%{ENTER}

