#include FcnLib.ahk

ForceWinFocus("Google Chrome", "Contains")
Sleep, 100
if NOT ClickIfImageSearch("images/chrome/extensions/pastebinIcon.bmp", "Control")
   fatalErrord("nolog", "couldn't find the pastebin icon image")
Sleep, 100
Send, {TAB 2}
Sleep, 100
Send, ^v
;SendRaw, %Clipboard%

Send, {TAB 2}
Sleep, 100
Send, camerb
Sleep, 100
Send, {TAB}
Sleep, 100
Send, {DOWN 3}
Sleep, 100
Send, {TAB 4}
Sleep, 100
Send, {ENTER}
;we sent the paste

SleepSeconds(1)
Send, {TAB 9}
Sleep, 100
Send, {ENTER}

Sleep, 100
Send, !d
Sleep, 100
Send, ^c
Sleep, 100
Send, ^w
