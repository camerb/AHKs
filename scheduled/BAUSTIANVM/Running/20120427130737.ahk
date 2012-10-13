#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120427130737.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120427130737.ahk")