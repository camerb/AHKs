#include FcnLib.ahk


#include firefly-FcnLib-fireflyRemote.ahk
SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-07-18_16-55-40)")

WatchVmDimensions()
;Loop, 5000
;{
   ;WinGetPos, no, no, winWidth, winHeight, - VMware Player
   ;msg := "VM Dimensions changed to " . , 
   ;if (winWidth != lastWidth)
      ;AddToTrace("VM Dimensions changed to " . winWidth . ", " . winHeight)

   ;lastWidth  := winWidth
   ;lastHeight := winHeight
   ;Sleep, 10
;}
;timestamp:=CurrentTime("hyphenated")
;AddToTrace("Finished watching dimensions at " . timestamp)
ExitApp

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120718165540.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120718165540.ahk")