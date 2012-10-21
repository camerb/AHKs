#include FcnLib.ahk


#include firefly-FcnLib-fireflyRemote.ahk
SetTitleMatchmode, 2
;VMsendText("!v")
;VMsendText("o")
;VMsendText("r")
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-07-18_15-48-05)")

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

;VMsendText(text)
;{
   ;ControlSend, , ,  - VMware Player
   ;Sleep, 100
;}

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120718154805.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120718154805.ahk")