#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-13_14-16-39)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120713141639.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120713141639.ahk")