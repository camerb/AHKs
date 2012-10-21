#include FcnLib.ahk


SetTitleMatchmode, 2
;VMsendText("!v")
;VMsendText("o")
;VMsendText("r")
ControlSend, , !vor,  - VMware Player
SleepSeconds(5)
addtotrace("red line - restarting VM remotely FORCEFULLY (queued at 2012-05-26_13-46-51)")

;VMsendText(text)
;{
   ;ControlSend, , ,  - VMware Player
   ;Sleep, 100
;}

#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120526134651.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120526134651.ahk")