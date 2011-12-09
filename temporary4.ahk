#include FcnLib.ahk

Loop, C:\Dropbox\AHKs\*, 0, 1
{
   if NOT RegExMatch(A_LoopFileName, "\.ahk$")
      continue
   if NOT InStr(A_LoopFileFullPath, "\thirdParty\")
      continue
   ;joe .= "`n" . A_LoopFileFullPath
   count += FileLineCount(A_LoopFileFullPath)
   files++
}
debug("notimeout nolog", count, files)
ExitApp ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Loop, C:\Dropbox\AHKs\*, 0, 1
{
   if NOT RegExMatch(A_LoopFileName, "\.ahk$")
      continue
   joe .= "`n" . A_LoopFileFullPath

}
debug("notimeout nolog", joe)
