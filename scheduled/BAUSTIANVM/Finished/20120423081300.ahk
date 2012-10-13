#include FcnLib.ahk


addtotrace("going to restart - red line")
Run, restart.ahk
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120423081300.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120423081300.ahk")