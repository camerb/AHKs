#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll" . " (queued at 2012-05-10_10-35-59)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120510103559.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120510103559.ahk")