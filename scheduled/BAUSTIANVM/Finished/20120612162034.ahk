#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-12_16-20-34)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120612162034.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120612162034.ahk")