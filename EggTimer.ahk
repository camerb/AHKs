#include FcnLib.ahk

timeToWait := prompt("How long would you like to set the timer for (in minutes)?`nOr, enter a timestamp if you want to be reminded later today... (like 17-23-00)")
msg := prompt("What message would you like to display?")
if (timeToWait=="")
   return

if RegExMatch(timeToWait, "^\d\d-\d\d-\d\d$")
{
   date := CurrentTime("hyphendate")
   time := DeFormatTime( date . "_" . timeToWait )
}
else if RegExMatch(timeToWait, "^\d\d-\d\d$")
{
   date := CurrentTime("hyphendate")
   time := DeFormatTime( date . "_" . timeToWait . "-00" )
}
else if RegExMatch(timeToWait, "^\d+$")
{
   ;if just a number, add that number to present time
   time:=AddDatetime(CurrentTime(), timeToWait, "minutes")
}
else
   errord("unsupported time", timeToWait, A_ScriptName, A_LineNumber)

filename=scheduled/%A_ComputerName%/%time%.ahk
text=MsgBox Hotkey Timer!!! Ring, ring!``n%msg%
FileAppend(text, filename)
