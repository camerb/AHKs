#include FcnLib.ahk


SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-05-25_15-26-33)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120525152633.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120525152633.ahk")