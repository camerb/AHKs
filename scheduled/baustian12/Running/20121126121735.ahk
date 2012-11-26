#include FcnLib.ahk


addtotrace("yellow line - launching VM remotely (queued at 2012-11-26_12-17-35)")
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
   msg := "VM Dimensions changed to " . , 
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
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121126121735.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121126121735.ahk")