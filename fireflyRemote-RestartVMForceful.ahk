#include FcnLib.ahk

;this script will forcefully restart the Home VM from any computer
; note that maybe we should move the check for VM window dimensions to the main script
;TODO maybe we need Firefly-FireflyRemote-FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
#include firefly-FcnLib-fireflyRemote.ahk
SetTitleMatchmode, 2
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at %timestamp%)")
WatchVmDimensions()
ExitApp

)

ScheduleRemoteAhk(ahkText, "baustian12")

;Loop, 5000
;{
   ;WinGetPos, no, no, winWidth, winHeight, - VMware Player
   ;msg := "VM Dimensions changed to " . %winWidth%, %winHeight%
   ;if (winWidth != lastWidth)
      ;AddToTrace("VM Dimensions changed to " . winWidth . ", " . winHeight)

   ;lastWidth  := winWidth
   ;lastHeight := winHeight
   ;Sleep, 10
;}
;timestamp:=CurrentTime("hyphenated")
;AddToTrace("Finished watching dimensions at " . timestamp)
