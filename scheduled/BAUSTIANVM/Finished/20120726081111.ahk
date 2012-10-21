#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-26_08-11-11)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120726081111.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120726081111.ahk")