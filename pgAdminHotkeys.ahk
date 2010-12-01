#include FcnLib.ahk

c::
Click
Click
Click
Click
Send, ^a^c
return

v::
Click
Click
Click
Click
Send, ^a^v
return

i::
Click
Click
Click
Click
Send, ^a^c
ClipWait
var:=Clipboard
;debug(var)
var+=1
;debug(var)
Send, ^a%var%
return

d::
Click
Click
Click
Click
Send, ^a^c
ClipWait
var:=Clipboard
;debug(var)
var-=1
;debug(var)
Send, ^a%var%
return

ESC::
Suspend
return
