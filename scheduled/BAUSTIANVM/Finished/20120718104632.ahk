#include FcnLib.ahk


addtotrace("orange line - restarting VM remotely (queued at 2012-07-18_10-46-32)")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120718104632.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120718104632.ahk")