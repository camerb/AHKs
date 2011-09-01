#include FcnLib.ahk

RunProgram("C:\Program Files\DOSBox-0.74\dosbox.exe")
Sleep 3000
text=mount a "C:\Dropbox\Programs\AIRBUCKS"
Send, %text%
Sleep 100
Send, {ENTER}
Sleep 100
Send, a:
Sleep 100
Send, {ENTER}
Send, airbuc12
Sleep 100
Send, {ENTER}

Loop 30
   Send, ^{F12}

SleepSeconds(1)
debug("use CTRL+F10 to toggle mouse control to outside apps", "hit alt-enter for fullscreen")
