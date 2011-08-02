#include FcnLib.ahk
#include thirdParty/todWulff.ahk

;Paste a url, rather than lots of text

;TODO parse the paste and figure out if it's ahk, perl, js, ini, diff or whatever
url := Paste2(Clipboard, "Paste from camerb")
SendViaClipboard(url)

