#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-12_16-06-26)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120612160626.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120612160626.ahk")