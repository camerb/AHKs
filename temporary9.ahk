#include FcnLib.ahk
#include thirdparty/notify.ahk

;why on earth doesn't this work???


Loop, C:\code\epms\, 2, 1
{
   if InStr(A_LoopFileFullPath, "C:\")
      addtotrace(A_LoopFileFullPath)
}
