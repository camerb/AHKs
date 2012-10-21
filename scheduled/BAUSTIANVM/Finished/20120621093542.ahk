#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-21_09-35-42)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120621093542.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120621093542.ahk")