#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-16_14-51-07)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120716145107.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120716145107.ahk")