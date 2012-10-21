#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-12_15-48-29)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120612154829.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120612154829.ahk")