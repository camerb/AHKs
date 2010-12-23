#include FcnLib.ahk


Run, http://paste.scsys.co.uk/

ForceWinFocus("pasting to magnet_web - Google Chrome", "Exact")
Click(686,  559, "Left Control")
Sleep, 100
Send, {CTRLDOWN}v{CTRLUP}
Sleep, 100
Click(72,  825, "Left Control")
Click(72,  805, "Left Control")
Click(72,  785, "Left Control")

ForceWinFocus("Your paste.* - Google Chrome", "RegEx")
Click(292,  135, "Left Control")
Click(292,  115, "Left Control")
Click(292,  95, "Left Control")

ForceWinFocus("magnet_web paste from Someone at .* - Google Chrome", "RegEx")
Send, !d
Send, ^c
Send, ^w
