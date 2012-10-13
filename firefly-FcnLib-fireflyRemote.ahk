#include FcnLib.ahk

WatchVmDimensions()
{
   ;TODO USEME!!!!
   vmWindow=%A_Space%- VMware Player

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
}
