#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-05-25_21-59-43)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120525215943.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120525215943.ahk")