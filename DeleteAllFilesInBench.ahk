#include FcnLib.ahk

dir=C:\code\bench

FileDeleteDirForceful(dir)

FileDeleteDirForceful(dir)
{
   if NOT DirExist(dir)
      return

   dir:=EnsureEndsWith(dir, "\")
   dir:=EnsureEndsWith(dir, "*")

   ;delete as many files as we possibly can (typically difficult in windows)
   Loop, %dir%, , 1
   {
      FileDelete, %A_LoopFileFullPath%
   }

   ;delete all the folders that we can
   Loop, %dir%, 2, 1
   {
      FileRemoveDir, %A_LoopFileFullPath%, 1
   }
}
