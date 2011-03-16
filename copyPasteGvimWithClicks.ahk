#include FcnLib.ahk

SetTitleMatchMode, RegEx

#IfWinActive GVIM
c::
Click
Click
Send, "{+}y
return
v::
Click
Click
Send, "{+}p
return
#IfWinActive

ESC:: ExitApp
