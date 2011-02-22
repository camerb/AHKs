#include FcnLib.ahk

;textInBox=You've hit the hotkey for the egg timer, how long would you like to set the timer for (in minutes)?
;InputBox timeToWait, Timer, %textInBox%
;if (timeToWait=="")
   ;return

time:=CurrentTime()
projtime:=AddTime(time, textInBox, "minute")

filename=scheduled/%A_ComputerName%/%projtime%.ahk
text= MsgBox Hotkey Timer!!! Ring, ring!
FileAppend(text, filename)

AddTime(timestamp, qty, units)
{
   timestamp += %qty%, %units%
   return timestamp
}
