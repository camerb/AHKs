#include FcnLib.ahk
#include thirdParty/todWulff.ahk

;testing TodWulff's lib

url := Paste2(Clipboard, "Paste from camerb")
url := Goo_gl(url)
Run, %url%
