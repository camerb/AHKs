#include FcnLib.ahk


SetTitleMatchmode, 2
;VMsendText("!v")
;VMsendText("o")
;VMsendText("r")
ControlSend, , !vor,  - VMware Player
;SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-07-17_04-02-23)")
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

;VMsendText(text)
;{
   ;ControlSend, , ,  - VMware Player
   ;Sleep, 100
;}

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120717040223.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120717040223.ahk")