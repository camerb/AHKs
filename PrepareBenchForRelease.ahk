#include FcnLib.ahk

;run this script after exporting from svn and before moving to argon

Loop, C:\code\bench-exp-*, 2
{
   debug(A_LoopFileFullPath)
   path=%A_LoopFileFullPath%\root\static\img
   FileRemoveDir, %path%, 1
   path=%A_LoopFileFullPath%\root\static\js\lib\ext
   FileRemoveDir, %path%, 1
   path=%A_LoopFileFullPath%\root\static\js\lib\MTSI
   FileRemoveDir, %path%, 1
   path=%A_LoopFileFullPath%\root\static\js\lib\ux
   FileRemoveDir, %path%, 1
}
