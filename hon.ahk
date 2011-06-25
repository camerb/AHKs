#include FcnLib.ahk

G_RetreatPosX=0
G_RetreatPosY=0

AppsKey & ESC:: Suspend

AppsKey & r:: Reload

AppsKey & s::
MouseGetPos, G_RetreatPosX, G_RetreatPosY
return

`::
SendMode, Event
MouseMove, G_RetreatPosX, G_RetreatPosY
Click, right, G_RetreatPosX, G_RetreatPosY
HonSend("{F1}")
HonSend("!w")
return

a::
HonSend("{F1}")
HonSend("q")
HonClick()
HonSend("{ESC}")
return

s::
HonSend("{F1}")
HonSend("w")
HonClick()
HonSend("{ESC}")
return

d::
HonSend("{F1}")
HonSend("e")
HonClick()
HonSend("{ESC}")
return

f::
HonSend("{F1}")
HonSend("r")
HonClick()
HonSend("{ESC}")
return

z::
HonSend("!q")
return

x::
HonSend("!w")
return

c::
HonSend("!e")
return

v::
HonSend("!r")
return

k::
HonSend("{enter}")
HonSend("k")
HonSend("{enter}")
return

LWin::
RWin::
return

HonSend(text)
{
   SendMode, Play
   Send, %text%
   Sleep, 100
}

HonClick()
{
   SendMode, Event
   Click
   Sleep, 100
}
