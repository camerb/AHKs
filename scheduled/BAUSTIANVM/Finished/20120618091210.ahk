#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-18_09-12-10)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120618091210.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120618091210.ahk")