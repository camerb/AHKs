#include FcnLib.ahk
#singleinstance force

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

counter := 1
raybar := 0

~LButton::
MouseClick left
if raybar = 1
counter := counter+1
return

H::
raybar := 1
Loop{
	if counter = 1
	send , A
	Sleep 500
	if counter = 2
	send , B
	Sleep 500
	if counter = 3
	send , C
	Sleep 500
	if counter > 3
	counter := 1
	}
return

E::
raybar :=0
return

+E::
raybar :=0
return

Q::
raybar :=0
return

+Q::
raybar :=0
return

G::
raybar :=0
return

+V::
raybar :=0
return

N::
raybar :=0
return

+N::
raybar :=0
return

PgDn::
raybar :=0
return

PgUp::
raybar :=0
return

WheelUp::
raybar :=0
return

+WheelDown::
raybar :=0
return

