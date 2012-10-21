#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-06-11_11-04-58)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120611110458.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120611110458.ahk")