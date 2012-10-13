#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-18_15-37-26)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120718153726.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120718153726.ahk")