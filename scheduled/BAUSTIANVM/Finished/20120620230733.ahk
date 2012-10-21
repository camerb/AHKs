#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-20_23-07-33)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120620230733.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120620230733.ahk")