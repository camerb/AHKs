#include FcnLib.ahk

;checking if last.fm window is no longer playing and needs to be restarted

lastFmWindow=Last.fm - Opera ahk_class OperaWindowClass

CustomTitleMatchMode("RegEx")
DetectHiddenWindows, On

now := CurrentTime()
futureTime := AddDatetime(now, 8, "minutes")
titletext := WinGetTitle(lastFmWindow)
debug(titletext, now, futureTime)

DetectHiddenWindows, Off
CustomTitleMatchMode("Default")
