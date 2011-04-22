#include FcnLib.ahk


lastFmWindow=Last.fm - Opera ahk_class OperaWindowClass

CustomTitleMatchMode("RegEx")
DetectHiddenWindows, On

now := CurrentTime()
futureTime := now
futureTime += 8, minutes
;futureTime := AddDatetime(now, 8, "minute")
titletext := WinGetTitle(lastFmWindow)
debug(titletext, now, futureTime)

DetectHiddenWindows, Off
CustomTitleMatchMode("Default")
