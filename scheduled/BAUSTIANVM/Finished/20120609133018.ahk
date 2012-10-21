#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-09_13-30-18)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120609133018.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120609133018.ahk")