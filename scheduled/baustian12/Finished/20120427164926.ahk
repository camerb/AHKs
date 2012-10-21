#include FcnLib.ahk


SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
SleepSeconds(10)
addtotrace("red line - restarting VM remotely FORCEFULLY")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120427164926.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120427164926.ahk")