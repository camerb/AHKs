#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-11_10-36-26)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120611103626.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120611103626.ahk")