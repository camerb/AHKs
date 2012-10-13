#include FcnLib.ahk

ForceWinFocus("Mozilla Thunderbird")
Send, {appskey}
Sleep, 50
Send, g1

Sleep, 200
Send, {appskey}
Sleep, 50
Send, f

ForceWinFocus("Write")
Sleep, 100
Send, !s{end} - I'm on it CB
Sleep, 100
Send, ^{enter}

