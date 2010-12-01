#include FcnLib.ahk

;delete as many files as we possibly can (typically difficult in windows)
Loop, C:\code\bench\*, , 1
{
   FileDelete, %A_LoopFileFullPath%
}

;delete all the folders that we can
Loop, C:\code\bench\*, 2, 1
{
   FileRemoveDir, %A_LoopFileFullPath%, 1
}
