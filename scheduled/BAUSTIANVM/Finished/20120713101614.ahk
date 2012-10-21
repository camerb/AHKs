#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-13_10-16-14)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120713101614.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120713101614.ahk")