#include FcnLib.ahk

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
CoordMode, Mouse, Screen
blah:=72

k::InputBox, blah
j::circle(200, blah) ; segs = how many sides
l::move(100, blah)   ; segs = angle



move(dis=32, ang=0)
{
	;~ static
	MouseGetPos, mx, my
	ang:=-ang*(3.141592653589793/180)
	mx:=dis*Cos(ang), my:=dis*Sin(ang)
	;~ list.=mx " --- " my "`n"
	;~ Clipboard = %list%
	MouseMove, %mx%, %my%, 0, R
}


circle(rad=100, seg=36, speed=200, offset=90)
{
	loop, %seg%
	{
		move(rad/10, A_Index*(360/seg)+offset)
		sleep, speed/seg
	}
}





 ~esc::ExitApp