#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-10_12-41-48)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120710124148.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120710124148.ahk")