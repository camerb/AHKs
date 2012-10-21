#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll" . " (queued at 2012-05-01_11-47-24)")
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120501114724.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120501114724.ahk")