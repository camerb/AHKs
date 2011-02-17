#include FcnLib.ahk
#include thirdparty/eval.ahk


readMe=17 + 3
; NewStrMath:= RegExReplace(readMe, "[A-Za-z '""_&?!]*[^(sin\(|cos\(|tan\(|pi|\d)/*-+\)]")
NewStr:=eval(readme)
MsgBox %readme% = %newstr%
