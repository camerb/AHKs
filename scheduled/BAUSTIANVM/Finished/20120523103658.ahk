#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-05-23_10-36-58)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120523103658.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120523103658.ahk")