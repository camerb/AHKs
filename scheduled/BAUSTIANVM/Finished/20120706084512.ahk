#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-06_08-45-12)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120706084512.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120706084512.ahk")