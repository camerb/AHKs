#include FcnLib.ahk

;make a commit in git

ForceWinFocus("MINGW32", "Contains")
Send, clear{ENTER}
Send, git status{ENTER}
Send, git add -p{ENTER}

;TODO perhaps we should ask about the commit message at first,
;then say: "does this change relate to 'fixed invalid email'?"
; doing that may make my commit messages awesome and frequent

loop
{
   ret := prompt("Would you like to include this item in the commit?`nOr, you can specify a commit message")
   ForceWinFocus("MINGW32", "Contains")
   if ret == ""
      ExitApp
   else if strlen(ret) == 1
      Send, %ret%{ENTER}
   else
      break
}

ForceWinFocus("MINGW32", "Contains")
SendInput, git ci -m"%ret%"{ENTER}
