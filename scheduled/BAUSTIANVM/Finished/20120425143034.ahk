#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120425143034.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120425143034.ahk")