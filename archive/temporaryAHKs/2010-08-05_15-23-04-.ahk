#include FunctionLibrary.ahk

SetTitleMatchMode, RegEx

#IfWinActive GVIM
c:: Send, "{+}y
v:: Send, "{+}p
#IfWinActive
