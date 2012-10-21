#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-16_17-30-51)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120716173051.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120716173051.ahk")