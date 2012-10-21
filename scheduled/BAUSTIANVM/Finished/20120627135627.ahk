#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-06-27_13-56-27)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120627135627.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120627135627.ahk")