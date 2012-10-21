#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-06-26_12-58-19)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120626125819.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120626125819.ahk")