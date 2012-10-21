#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-13_11-06-15)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120613110615.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120613110615.ahk")