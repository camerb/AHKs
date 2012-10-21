#include FcnLib.ahk


#include firefly-FcnLib-fireflyRemote.ahk
SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-07-20_16-40-37)")
WatchVmDimensions()
ExitApp

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120720164037.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120720164037.ahk")