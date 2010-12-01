#include FcnLib.ahk

;TODO put this in a function
;TODO make an ahk that is singleinstance, and
;TODO show these messages in the corner of the screen
;TODO show overlapping messages nicely

	;CustomColor = EEAA99
	;Gui, 2:+LastFound -Caption +ToolWindow +AlwaysOnTop
	;Gui, 2:Color, %CustomColor%
	;Gui, 2:Font, s18
	;Gui, 2:Add, Text, cLime, winner wins!
	;WinSet, TransColor, %CustomColor% 150
	;Gui, 2:Show, NoActive
;SleepSeconds(5)
	;Gui, 2:Add, Text, cLime, joe joe wins!
	;WinSet, TransColor, %CustomColor% 150
	;Gui, 2:Show, NoActive
;SleepSeconds(5)
;ExitApp



message("msg")

;TODO put this in a function
;TODO make an ahk that is singleinstance, and
;TODO show these messages in the corner of the screen
;TODO show overlapping messages nicely
overlayMessage(message)
{
	CustomColor = 000000
	Gui, 2:+LastFound -Caption +ToolWindow +AlwaysOnTop
	Gui, 2:Color, %CustomColor%
	Gui, 2:Font, s18
	Gui, 2:Add, Text, cRed, %message%
	WinSet, TransColor, %CustomColor% 150
	Gui, 2:Show, NoActive
SleepSeconds(5)
WinClose
}
