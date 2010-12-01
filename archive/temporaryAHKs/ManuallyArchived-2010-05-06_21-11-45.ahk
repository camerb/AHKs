#include FcnLib.ahk

Run, http://paste.scsys.co.uk/

ForceWinFocus("pasting to magnet_web - Google Chrome", "Exact")
Click(686,  559, "Left Control")
Sleep, 100
Send, {CTRLDOWN}v{CTRLUP}
Sleep, 100
Click(72,  825, "Left Control")

ForceWinFocus("Your paste.* - Google Chrome", "RegEx")
Click(292,  131, "Left Control")

ForceWinFocus("magnet_web paste from Someone at .* - Google Chrome", "RegEx")
Send, !d
Send, ^c
