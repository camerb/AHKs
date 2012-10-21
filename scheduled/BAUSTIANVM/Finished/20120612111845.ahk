#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-12_11-18-45)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120612111845.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120612111845.ahk")