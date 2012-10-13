#include FcnLib.ahk

;back up firefly scripts snapshot

datestamp := CurrentTime("hyphendate")

Loop, C:\Dropbox\AHKs\firefly*.ahk
{
   thisFullPath := A_LoopFileFullPath
   thisFile := A_LoopFileName

   dest=C:\Dropbox\AHKs\gitExempt\fireflyArchive\%datestamp%\%thisFile%

   FileCopy(thisFullPath, dest)
}
