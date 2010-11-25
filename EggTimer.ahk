#include FunctionLibrary.ahk

textInBox=You've hit the hotkey for the egg timer, how long would you like to set the timer for (in minutes)?
InputBox timeToWait, Timer, %textInBox%
if (timeToWait=="")
	return
SleepMinutes(timeToWait)
MsgBox Hotkey Timer!!! Ring, ring!

;currentTime:=CurrentTime()
;timeToWait*=100
;timeToWaitUntil:=TimePlus(currentTime, timeToWait)
;textInBox=MsgBox Hotkey Timer!!! Ring, ring!
;FileAppend, %textInBox%, %timeToWaitUntil%.ahk
