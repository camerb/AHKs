#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-15_14-07-30)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120615140730.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120615140730.ahk")