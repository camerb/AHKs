#include FcnLib.ahk

;deleting "conflicted copy files from dropbox automatically

DeleteConflictedCopies("C:\Dropbox\Public\logs")
DeleteConflictedCopies("C:\Dropbox\Public\lock")
DeleteConflictedCopies("C:\Dropbox\Programs\CLCL\Administrator")

SHOWConflictedCopies("C:\Dropbox")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DeleteConflictedCopies(path)
{
   path := EnsureEndsWith(path, "\")
   path .= "*"

   Loop, %path%, 0, 1
   {
      if NOT InStr(A_LoopFileName, "conflicted copy")
         continue

      out .= "`n"
      out .= A_LoopFileFullPath
      FileDelete(A_LoopFileFullPath)
   }

   ;debug("nolog notimeout", out)
}

showConflictedCopies(path)
{
   path := EnsureEndsWith(path, "\")
   path .= "*"

   Loop, %path%, 0, 1
   {
      if NOT InStr(A_LoopFileName, "conflicted copy")
         continue

      out .= "`n"
      out .= A_LoopFileFullPath
   }

   debug("nolog notimeout", out)
}
