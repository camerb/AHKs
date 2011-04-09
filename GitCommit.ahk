#include FcnLib.ahk

;make a commit in git

ForceWinFocus("MINGW32", "Contains")
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
   else if (strlen(ret) == 1)
      SendInput, %ret%{ENTER}
   else
      break
}

if NOT commitMessage
   ExitApp

ForceWinFocus("MINGW32", "Contains")
SendInput, git ci -m"%commitMessage%"{ENTER}
