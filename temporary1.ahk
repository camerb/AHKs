#include FcnLib.ahk

Loop
{

GetKeyState, JoyX, JoyX  ; Get position of X axis. (0-100) 50 is mid
;GetKeyState, JoyY, JoyY  ; Get position of Y axis.
;debug(joyX, joyY)


;addtotrace(joyx)
direction=right
if (joyX < 50)
   direction=left
;addtotrace(direction)

mult:=2
if (45 < joyX and joyx < 55)
   mult:=0.2
if (40 < joyX and joyx < 60)
   mult:=0.5
if (35 < joyX and joyx < 65)
   mult:=1.2
if (30 < joyX and joyx < 70)
   mult:=1.7

;mult:=0.9
;if (45 < joyX and joyx < 55)
   ;mult:=0.1
;if (40 < joyX and joyx < 60)
   ;mult:=0.2
;if (35 < joyX and joyx < 65)
   ;mult:=0.35
;if (30 < joyX and joyx < 70)
   ;mult:=0.6

speed:=joyx-50
speed:=abs(speed)*mult

;if NOT (47 < joyX and joyx < 49)
   move(direction,speed)

sleep, 20
}

Joy1::ControlSend, , x
Joy2::Send, c
Joy4::Send, c

`::ExitApp

move(direction, speed)
{
   dist := 1 * speed
   speed := 2 / speed
   if (direction = "left")
      dist *= -1
   MouseMove, %dist%, 0, %speed%, R
}
