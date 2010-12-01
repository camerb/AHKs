#include FcnLib.ahk

;delete as many files as we possibly can (typically difficult in windows)
Loop, C:\code\bench\*, , 1
{
   FileDelete, %A_LoopFileFullPath%
}
;FileRemoveDir, C:\code\bench, 1
