#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-05-30_11-06-55)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120530110655.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120530110655.ahk")