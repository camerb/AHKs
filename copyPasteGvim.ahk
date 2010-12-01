#include FcnLib.ahk

SetTitleMatchMode, RegEx

#IfWinActive GVIM
c:: Send, "{+}y
v:: Send, "{+}p
#IfWinActive

ESC:: ExitApp
