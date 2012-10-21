#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-21_10-06-06)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120621100606.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120621100606.ahk")