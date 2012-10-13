#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll" . " (queued at 2012-04-30_12-52-32)")
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120430125232.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120430125232.ahk")