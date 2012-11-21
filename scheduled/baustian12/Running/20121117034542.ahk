#include FcnLib.ahk


#include firefly-FcnLib-fireflyRemote.ahk
SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-11-17_03-45-42)")
WatchVmDimensions()
ExitApp

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121117034542.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121117034542.ahk")