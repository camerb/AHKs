#include FcnLib.ahk

ss()
;need to click on the fees button
;Click(496, 807, "left")

ss()
Click(646, 664, "left")
ss()
Send, client
Click(618, 688, "left")
ss()
Click(821, 666, "left")
ss()
Send, locate
Click(776, 684, "left")
ss()
Click(890, 669, "left")
ss()
Send, 45
Click(611, 476, "left")
ss()

;this should be done after the loop
;Click(1246, 425, "left")
ss()

ESC::ExitApp
`::ExitApp

ss()
{
Sleep, 100
}
