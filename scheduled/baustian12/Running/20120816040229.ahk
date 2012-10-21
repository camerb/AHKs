#include FcnLib.ahk


#include firefly-FcnLib-fireflyRemote.ahk
SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-08-16_04-02-29)")
WatchVmDimensions()
ExitApp

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120816040229.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120816040229.ahk")