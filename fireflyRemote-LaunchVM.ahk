#include FcnLib.ahk

;this script will forcefully restart the Home VM from any computer
; note that maybe we should move the check for VM window dimensions to the main script
;TODO maybe we need Firefly-FireflyRemote-FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
addtotrace("yellow line - launching VM remotely (queued at %timestamp%)")
RunAhk("LaunchVM.ahk")
SetTitleMatchmode, 2
WinWait, - VMware Player, , 20
if ERRORLEVEL
   AddToTrace("Window Never Showed Up! - VMware Player")
WinMinimize, - VMware Player
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
)

ScheduleRemoteAhk(ahkText, "baustian12")
