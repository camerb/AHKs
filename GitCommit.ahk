#include FcnLib.ahk
#include FcnLib-Misc.ahk

;make a commit in git

;maybe we need to make all of this prep stuff into a function
ForceWinFocus("MINGW32", "Contains")
SendInput, q{ENTER}
SendInput, clear{ENTER}
;SendInput, git add --all{ENTER} ;need something that will only stage new files
SendInput, git status{ENTER}
SendInput, git add -p{ENTER}

;TODO perhaps we should ask about the commit message at first,
;then say: "does this change relate to 'fixed invalid email'?"
; doing that may make my commit messages awesome and frequent
commitMessage := prompt("Specify a commit message:")

Loop
{
   ret := prompt("Commit Message: " . commitMessage . "`nWould you like to include this item in the commit?")
   ForceWinFocus("MINGW32", "Contains")
   if (ret == "")
      ExitApp
   else if (ret == "f")
      break
   else if (ret == "a")
      break
   else if (strlen(ret) == 1)
      SendInput, %ret%{ENTER}
   else
      break
}

ForceWinFocus("MINGW32", "Contains")
SendInput, q{ENTER}

if NOT commitMessage
   ExitApp

;add all new files if they told us to...
if (ret == "a")
   SendInput, git add --all{ENTER}

currentBranchName := GitGetCurrentBranchName()
issueNumber := GitGetIssueNumber(currentBranchName)
issueTitle := RemoveLineEndings(GitGetIssueTitle(issueNumber))

fullCommitMessage=%issueNumber% - %issueTitle% - %commitMessage%
fullCommitMessage := StringReplace(fullCommitMessage, """", "'")
fullCommitMessage := RegExReplace(fullCommitMessage, " +", " ")

ForceWinFocus("MINGW32", "Contains")
SendInput, git ci -m"%fullCommitMessage%"{ENTER}
