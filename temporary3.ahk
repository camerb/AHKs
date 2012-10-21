#include FcnLib.ahk
#include FcnLib-Clipboard.ahk

;Loop, read, wordlist-weighted-1200.txt
;{

;}

ForceWinFocus("Google Chrome ahk_class Chrome_WidgetWin_1")

Send, ^1
Loop, 50
{
   Send, !d
   ;Send, ^c
   Sleep, 1000
   url := CopyWait2()

   Sleep, 100
   Send, ^{pgdn}
   Sleep, 1000
   FileAppend(url . "`n", "LinkList.txt")
}
