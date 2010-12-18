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
Sleep, 50
HonSend("!w")
return

;q::
;HonSend("{F1}")
;Sleep, 50
;HonSend("q")
;Sleep, 100
;HonClick()
;Sleep, 100
;HonSend("{ESC}")
;return

;w::
;HonSend("{F1}")
;Sleep, 50
;HonSend("w")
;Sleep, 100
;HonClick()
;Sleep, 100
;HonSend("{ESC}")
;return

;e::
;HonSend("{F1}")
;Sleep, 50
;HonSend("e")
;Sleep, 100
;HonClick()
;Sleep, 100
;HonSend("{ESC}")
;return

;r::
;HonSend("{F1}")
;Sleep, 50
;HonSend("r")
;Sleep, 100
;HonClick()
;Sleep, 100
;HonSend("{ESC}")
;return

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
Sleep, 50
HonSend("k")
Sleep, 50
HonSend("{enter}")
return

HonSend(text)
{
   SendMode, Play
   Send, %text%
}

HonClick()
{
   SendMode, Event
   Click
}
