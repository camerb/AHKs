#include FcnLib.ahk
#include FcnLib-Misc.ahk
#include ThirdParty/CmdRet.ahk

currentBranchName := GitGetCurrentBranchName()

if InStr(currentBranchName, "pushed")
   fatalErrord("", currentBranchName, "This branch has already been pushed to origin")

if NOT RegExMatch(currentBranchName, "(EPMS|FLB|SM|LXS|LYNX)")
   fatalErrord("", currentBranchName, "It looks like this branch is not part of a recognized project")

ForceWinFocus("MINGW32", "Contains")
Send, git status{ENTER}
Send, git push origin %currentBranchName%{ENTER}
Send, git branch -m %currentBranchName% pushed/%currentBranchName%{ENTER}

message=The branch origin/%currentBranchName% is ready to move live`n`n

RegExMatch(currentBranchName, "(\w+-\d+)", match)
issueNumber := match1

command=perl C:\code\mtsi-scripts\jira-issue-title.pl %issueNumber%
issueTitle := CmdRet_RunReturn( command )
message .= issueTitle
subject = Branch to merge [%currentBranchName%]
;debug(message)

if InStr(message, "exception")
   message := Prompt("The message that will be sent to Nathan is as follows, it looks like it contains an exception, so please revise it:`n`n" . message)

SleepSeconds(15)
;SendEmail(subject, message, "", "nathan@mitsi.com", "cameronbaustian@gmail.com")
