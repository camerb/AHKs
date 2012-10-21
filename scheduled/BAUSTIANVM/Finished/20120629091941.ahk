#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-06-29_09-19-41)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120629091941.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120629091941.ahk")