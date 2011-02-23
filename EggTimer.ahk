#include FcnLib.ahk

timeToWait := prompt("How long would you like to set the timer for (in minutes)?")
if (timeToWait=="")
   return

time:=CurrentTime()
time:=AddTime(time, timeToWait, "minutes")

filename=scheduled/%A_ComputerName%/%time%.ahk
text= MsgBox Hotkey Timer!!! Ring, ring!
FileAppend(text, filename)

AddTime(timestamp, qty, units)
{
   ;orig:=timestamp
   timestamp += %qty%, %units%
   ;debug(timestamp, orig)
   return timestamp
}
