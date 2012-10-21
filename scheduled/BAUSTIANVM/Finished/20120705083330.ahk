#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-05_08-33-30)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120705083330.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120705083330.ahk")