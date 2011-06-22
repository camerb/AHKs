#include FcnLib.ahk

gui, show, w365 h250, The Cookiezi Killer v1.42b
gui, font, s14 bold underline, Verdana
gui, add, text,, -- The Cookiezi Killer v1.42b --
gui, font, s14 Norm, Verdana
gui, font, s9, Verdana
gui, add, text,, Ctrl + R = Recording ||| R = Stop Recording`nCtrl + P = Playback ||| P = Stop Playback
gui, add, button,, Select New File
gui, font, s7, Verdana
gui, add, text,, Loaded '%RecordingFileName%' recording



 ~esc::ExitApp