#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-11_11-18-30)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120611111830.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120611111830.ahk")