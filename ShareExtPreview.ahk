#include FcnLib.ahk

path=C:\code\EPMS_parts\
sharedPath=%path%shared
workingPath=%path%working

FileCopyDir, %workingPath%, %sharedPath%, 1

Loop, %sharedPath%\*.xds
   FileDelete, %A_LoopFileFullPath%
