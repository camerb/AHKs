#include FcnLib.ahk

;this script will forcefully restart the Home VM from any computer
; note that maybe we should move the check for VM window dimensions to the main script
;TODO maybe we need Firefly-FireflyRemote-FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
SetTitleMatchmode, 2
;VMsendText("!v")
;VMsendText("o")
;VMsendText("r")
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at %timestamp%)")
Loop, 5000
{
   WinGetPos, no, no, winWidth, winHeight, - VMware Player
   ;if (winWidth != 1298 AND winHeight != 1017)
   msg := "VM Dimensions changed to " . %winWidth%, %winHeight%
   if (winWidth != lastWidth)
      AddToTrace("VM Dimensions changed to " . winWidth . ", " . winHeight)
      ;debug(winWidth, winHeight, lastWidth, lastHeight, msg)

   lastWidth  := winWidth
   lastHeight := winHeight
   Sleep, 10
}
timestamp:=CurrentTime("hyphenated")
AddToTrace("Finished watching dimensions at " . timestamp)
ExitApp

;VMsendText(text)
;{
   ;ControlSend, , %text%,  - VMware Player
   ;Sleep, 100
;}

)

ScheduleRemoteAhk(ahkText, "baustian12")
