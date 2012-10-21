#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-17_13-25-08)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120717132508.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120717132508.ahk")