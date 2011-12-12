;SnowFight! by ton80
;Default Controls
;	A			=		Walk Left
;	D			=		Walk Right
;	S			=		Crouch (Gather more snow)
;	LButton 	= 		Throw snowball, holding button increases velocity (watch bar on top)
;	Space		=		Jump
;	Esc			=		Exit
;	F1			=		Show Frame Rate
;	F2			=		Toggle Auto FPS adjust
;	F3			=		Snow Harder (will slow down the game)
;	F4			=		Snow Less (will speed up the game)

SetBatchLines, -1
#NoEnv
#SingleInstance, Force
CoordMode, Tooltip, Screen
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

SysGet, MonitorWorkArea, MonitorWorkArea,"1"							;Get the height of the screen, minus the taskbar
boardHeight := MonitorWorkAreaBottom									;Height of the window
boardWidth := A_ScreenWidth												;Width of the window
gosub, Initialize_Color_Values												;Assigns color names to BGR value
gosub, Initialize_Variables												;Sets the initial game variables
gosub, Initialize_Graphics												;Set up the graphics (pens, brushes, etc)
gosub, Change_Wind														;Get the initial Wind_Speed
gosub, Initialize_Snowflakes											;Creates array of Snowflakes
gosub, Initialize_Landscape												;Creates the landscape (ground)
gosub, Initialize_Player_Regions										;Creates the player
gosub, Initialize_SnowMan_Regions										;Creates the Snowman
Start_Time := A_TickCount
gosub, main_loop
SetTimer, keepawake, 60000
run, sf2.ahk
return

keepawake:					; temp routine to keep cpu from sleeping
MouseMove, snowman_snowball_x, snowman,snowball_y
return

;###################################################################################################
;Main Loop
;###################################################################################################
Main_Loop:
;Critical
Loop
	{
		gosub, Snowflakes_Animate											;Move Snowflakes
		gosub, Player_1_Move_Arm											;Make arm follow mouse
		
		Loop, Parse, Player_1_Controls, csv									;Check for player movement
			If (GetKeyState(%A_Loopfield%, "P"))						;Check to see if player has moved
				gosub, %A_LoopField%
			
		If (Player_1_Throwing)												;Check if ball has been thrown
			gosub, Player_1_Throw
		If (Player_1_Jumping)												;If player in the air, bring them down
			gosub, Player_1_Jumping
		If (Player_1_Squatting)												;If player squatting, stand them up
			gosub, Player_1_Squatting
		
		gosub, Snowman_Throwing
		
		If (Display_Frame_Rate)												;show framerate if its on
			gosub, Display_Frame_Rate
		
		If (Auto_Adjust_FPS)
			gosub, Auto_Adjust_FPS
		
		gosub, Change_Wind																;check/change wind if its time
		gosub, update_screen
	}	
return
;###################################################################################################
;Display Info
;###################################################################################################
Toggle_Auto_Adjust_FPS:
If (Toggle_Auto_Adjust_FPS) & (A_TickCount - Toggle_Auto_Adjust_FPS < 100)		;stops from rapid keypress
	return
Toggle_Auto_Adjust_FPS := A_TickCount
If (!Auto_Adjust_FPS)
	Auto_Adjust_FPS := 1
else
	Auto_Adjust_FPS := 0
return

Calculate_Frame_Rate:
Run_Time := A_TickCount - Start_Time
Run_Time /= 1000
Frame_Rate := Round(Frames / Run_Time)
Frame_Rate_Display := "avg fps : " Frame_Rate
return

Auto_Adjust_FPS:
target_fps := 80
gosub, Calculate_Frame_Rate
if (frame_rate < target_fps - 10)
	snowflake_count -=25	
else if (frame_rate  > target_fps + 10)
	snowflake_count +=25
else return
gosub, Initialize_Snowflakes

Adjusting_FPS_Message := "Adjusting FPS"
DllCall("TextOut", "Int", hdcMem, "Int", boardwidth - 150, "Int", 0, "Int", &Adjusting_FPS_Message, "Int", StrLen(Adjusting_FPS_Message))
ToolTip, %snowflake_count%, mx+50, my
return

Toggle_Frame_Rate:
If (Toggle_Frame_Rate_Time) & (A_TickCount - Toggle_Frame_Rate_Time < 100)		;stops from rapid keypress
	return
Toggle_Frame_Rate_Time := A_TickCount
If (!Display_Frame_Rate)
	Display_Frame_Rate := 1
else
	Display_Frame_Rate := 0
return


Display_Frame_Rate:
If (Display_Frame_Rate = 0)
	return
If (Display_Frame_Rate = 1)
	{
		gosub, Calculate_Frame_Rate
		DllCall("TextOut", "Int", hdcMem, "Int", boardwidth - 150, "Int", 0, "Int", &Frame_Rate_Display, "Int", StrLen(Frame_Rate_Display))
	}
return

Snowflake_More:
If (Snowflake_More_Time) & (A_TickCount - Snowflake_More_Time < 1000)		;stops from rapid keypress
	return
Snowflake_More_Time := A_TickCount
Snowflake_Count += 50
ToolTip, %Snowflake_Count%, boardwidth - 50, 50
gosub, Initialize_Snowflakes
return

Snowflake_Less:
If (Snowflake_Less_Time) & (A_TickCount - Snowflake_Less_Time < 1000)		;stops from rapid keypress
	return
Snowflake_Less_Time := A_TickCount
Snowflake_Count -= 50
If (Snowflake_Count < 0)
	Snowflake_Count := 0
ToolTip, %Snowflake_Count%, boardwidth - 50, 50
gosub, Initialize_Snowflakes
return


Snowman_Throwing:
If (!Snowman_Throwing)				; snowman is not currently throwing, so give him a snowball
	{
		snowman_snowballs_thrown ++
		Snowman_Snowball_Size := rnd(15, 40)
		DllCall("Ellipse", "Int", hdcMem, "Int", Snowman_Hand_X - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_X + Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y + Snowman_Snowball_Size / 2)
		Snowman_Throwing := 1
	}
Else If (Snowman_Throwing = 1)		; snowman has a snowball, but isnt throwing it yet, so cock his arm back
	{
		Snowman_Hand_X += 10
		Snowman_Snowball_X += 10
			If (Snowman_Hand_X > Snowman_X + 150)
				Snowman_Throwing := 2
		DllCall("Ellipse", "Int", hdcMem, "Int", Snowman_Hand_X - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_X + Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y + Snowman_Snowball_Size / 2)
	}
Else If (Snowman_Throwing = 2)		;snowman has a snowball, and his arm is cocked back, so bring arm forward
	{
		Snowman_Hand_X -=20
		Snowman_Snowball_X -=20
			If (Snowman_Hand_X < Snowman_X - 100)
				Snowman_Throwing := 3
			;else MsgBox %snowman_Hand_X%`r`n%snowman_x%
		DllCall("Ellipse", "Int", hdcMem, "Int", Snowman_Hand_X - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_X + Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y + Snowman_Snowball_Size / 2)
	}
Else If (Snowman_Throwing = 3)		;Create random angle and velocity
	{
		Snowman_Snowball_Velocity := rnd(120, 180) - Snowman_Snowball_Size
		Snowman_Snowball_Angle := rnd(135,180)
		s_theta := Snowman_Snowball_Angle * .01745329252
		s_vix := Snowman_Snowball_Velocity * cos(s_theta)
		s_viy := Snowman_Snowball_Velocity * sin(s_theta)
		s_ix := Snowman_Hand_X
		s_iy := Snowman_Hand_Y
		Snowman_Snowball_Y := s_iy
		Snowman_Snowball_X := s_ix
		s_ax	:= Wind_Speed
		s_ay	:= -9.80665
		s_ts 	:= A_TickCount
		s_gy	:= A_ScreenHeight
		_moveto(hdcMem,ix,iy)
		Snowman_Throwing := 4
		DllCall("Ellipse", "Int", hdcMem, "Int", Snowman_Hand_X - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y - Snowman_Snowball_Size / 2,"Int",Snowman_Hand_X + Snowman_Snowball_Size / 2,"Int",Snowman_Hand_Y + Snowman_Snowball_Size / 2)
	}
Else If (Snowman_Throwing = 4)		;Create the snowmans, snowball region
	{
		; changed. not needed
		Snowman_Throwing := 5
	}
Else If (Snowman_Throwing = 5)		;Move the snowball
	{
		Snowman_Snowball_XP := Snowman_Snowball_X
		Snowman_Snowball_YP := Snowman_Snowball_Y
		s_t := round((A_TickCount - s_ts)/1000,5)	* 6					; * playback speed
		Snowman_Snowball_Y := s_viy * s_t + .5 * s_ay * s_t**2
		Snowman_Snowball_Y := s_iy - Snowman_Snowball_Y
		Snowman_Snowball_X :=  s_vix * s_t + .5 * s_ax * s_t**2
		Snowman_Snowball_X += s_ix
		Snowman_Snowball_X_Offset 	:= Snowman_Snowball_X - Snowman_Snowball_XP
		Snowman_Snowball_Y_Offset	:= Snowman_Snowball_Y - Snowman_Snowball_YP
		DllCall("Ellipse", "Int", hdcMem, "Int", Snowman_Snowball_X,"Int",Snowman_Snowball_Y,"Int",Snowman_Snowball_X + Snowman_Snowball_Size,"Int",Snowman_Snowball_Y + Snowman_Snowball_Size)
		gosub, Snowman_Snowball_Check_for_Collision
	}

return

Snowman_Snowball_Check_for_Collision:
If (Snowman_Snowball_X + Snowman_Snowball_Size < -50) or (Snowman_Snowball_Y > boardheight)
			{
				Snowman_Throwing := 0
				DllCall("DeleteObject", "Int", Snowman_Snowball)
			}
Else If DllCall("PtInRegion", "Int", Landscape, "Int", Snowman_Snowball_X + Snowman_Snowball_Size /2, "Int",Snowman_Snowball_Y + Snowman_Snowball_Size /2)
		gosub, Snowman_Snowball_Hit_Ground
Else If (Snowman_Snowball_X <= Player_1_X) & (Snowman_Snowball_X + Snowman_Snowball_Size >= Player_1_X) & (Snowman_Snowball_Y >= Player_1_Y - 20)
		gosub, Snowman_Snowball_Hit_Player_1

return

Snowman_Snowball_Hit_Ground:										; If snowball hits ground, add it to the landscape
SoundPlay, ironchip.wav
Snowman_Snowball := DllCall("CreateEllipticRgn", "Int", Snowman_Snowball_X, "Int", Snowman_Snowball_Y, "Int", Snowman_Snowball_X + Snowman_Snowball_Size, "Int", Snowman_Snowball_Y + Snowman_Snowball_Size)
DllCall("CombineRgn", "Int", Landscape, "Int", Landscape, "Int",Snowman_Snowball , "Int", 2)
DllCall("DeleteObject", "Int", Snowman_Snowball)
Snowman_Throwing := 0
return

Snowman_Snowball_Hit_Player_1:
Snowman_Points ++ 
Player_1_Hit := 1
Player_1_Hit_Time := A_TickCount
return

left::
Snowman_Move_Left:
Snowman_X -=5
Snowman_Arm_X -=5
Snowman_Hand_X -=5
DllCall("OffsetRgn", "Int", Snowman, "Int", -5, "Int", 0)
return

right::
Snowman_Move_Right:
Snowman_X +=5
Snowman_Arm_X +=5
Snowman_Hand_X +=5
DllCall("OffsetRgn", "Int", Snowman, "Int", +5, "Int", 0)
return


Up::
Snowman_Move_Up:
Snowman_Y -=5
Snowman_Arm_Y -=5
Snowman_Hand_Y -=5
DllCall("OffsetRgn", "Int", Snowman, "Int",0, "Int", -5)
return

down::
Snowman_Move_Down:
Snowman_Y +=5
Snowman_Arm_Y +=5
Snowman_Hand_Y +=5
DllCall("OffsetRgn", "Int", Snowman, "Int",0, "Int", +5)
return

snowman_draw:
; fill body
DllCall("FillRgn", "Int", hdcMem, "Int", Snowman, "Int", Brush_Snowman)
DllCall("SelectObject","UInt", hdcMem, "UInt", Pen_Snowman_Arms)

; draw arm
_MoveTo(HdcMem, Snowman_Arm_X, Snowman_Arm_Y)
_LineTo(HdcMem, Snowman_Hand_X, Snowman_Hand_Y)

return



;###################################################################################################
;Player Movement
;###################################################################################################
Player_1_Left:
If (Player_1_Squatting) or (Player_1_Hit)
	return
Player_1_X -= Player_1_Walk_Speed
If(Player_1_X <= 50)
	Player_1_X := 50
;check to make sure not above or below the ground level
If (!Player_1_Jumping)							
{
	If (Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height+1))
		While (Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height))
			Player_1_Y --
	Else If (!Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height+1))
		While (!Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height))
			Player_1_Y ++
}
return

Player_1_Right:
If (Player_1_Squatting) or (Player_1_Hit)
	return
Player_1_X += Player_1_Walk_Speed
If(Player_1_X > boardwidth - 50)
	Player_1_X := boardWidth - 50
;check to make sure not above or below the ground level
If (!Player_1_Jumping)							
{
	If (Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height+1))
		While (Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height))
			Player_1_Y --
	Else If (!Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height+1))
		While (!Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height))
			Player_1_Y ++
}
return

Player_1_Down:
If (Player_1_Throwing) or (Player_1_Hit)										;cant increase snowball size if its airborne.
	return
If (!Player_1_Squatting) & (!Player_1_Jumping) & (!Player_1_Hit)
	{
		Player_1_Height := Player_1_Height_Default / 2
		Player_1_Y += Player_1_Height
		Player_1_Squatting := 1
		MouseMove, Player_1_X+100, boardHeight
	}

Player_1_Snowball_Size += .5
	If(Player_1_Snowball_Size > 35)
		Player_1_Snowball_Size := 35
DllCall("Ellipse", "Int", hdcMem, "Int", Player_1_Hand_X - Player_1_Snowball_Size / 2,"Int",Player_1_Hand_Y - Player_1_Snowball_Size / 2,"Int",Player_1_Hand_X + Player_1_Snowball_Size / 2,"Int",Player_1_Hand_Y + Player_1_Snowball_Size / 2)
return

Player_1_Up:					;does nothing currently
If (!Player_1_Squatting) 
	return
Player_1_Y -= Player_1_Height,Player_1_Height := Player_1_Height_Default,Player_1_Squatting := 0
return

Player_1_Jump:
If (!Player_1_Jumping) & (!Player_1_Hit)
		Player_1_Y -= Player_1_Jump_Height, Player_1_Jumping := 1
return

Player_1_Jumping:
If (!Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height))
	Player_1_Y += 4
else
	Player_1_Jumping := 0
return

Player_1_Squatting:
Player_1_Height += 4
If (Dllcall("PtInRegion", "Int", Landscape, "Int", Player_1_X, "Int", Player_1_Y + Player_1_Height))
	Player_1_Y -= 4

If (Player_1_Height >= Player_1_Height_Default)
	Player_1_Height := Player_1_Height_Default, Player_1_Squatting := 0
return



Player_1_Hit:
If (A_TickCount - Player_1_Hit_Time > 2000)
	Player_1_Hit := 0

;redraw players
DllCall("SelectObject","UInt", hdcMem, "UInt", Pen_Player_1)
DllCall("SelectObject","UInt", hdcMem, "UInt", Brush_Player_1)

;generic body
_MoveTo(hdcMem, Player_1_X, Player_1_Y + Player_1_Height)
_LineTo(hdcMem, Player_1_X - Player_1_Height, Player_1_Y + Player_1_Height)
;arm
_MoveTo(hdcMem, Player_1_X-80, Player_1_Y + Player_1_Height)
_LineTo(HdcMem, Player_1_X-80, Player_1_Y + Player_1_Height - 40)

DllCall("Ellipse", "Int", hdcMem, "Int", Player_1_X - Player_1_Height -10,"Int",Player_1_Y + Player_1_Height - 10,"Int",Player_1_X - Player_1_Height +10,"Int",Player_1_Y + Player_1_Height + 10)

return



esc::
GuiClose:
OnExit:
DllCall("DeleteObject", "Int", hbm)
DllCall("DeleteObject", "Int", Pen)
DllCall("DeleteObject", "Int", Pen_Player_1)
DllCall("DeleteObject", "Int", Pen_Snowflake)
DllCall("DeleteObject", "Int", Pen_Snowball)
DllCall("DeleteObject", "Int", Pen_Hud)
DllCall("DeleteObject", "Int", Pen_Snowman_Arms)
DllCall("DeleteObject", "Int", Brush_Background)
DllCall("DeleteObject", "Int", Brush_Snowflake)
DllCall("DeleteObject", "Int", Brush_Snowball)
DllCall("DeleteObject", "Int", Brush_Snowman_Snowball)
DllCall("DeleteObject", "Int", Brush_Landscape)
DllCall("DeleteObject", "Int", Brush_Hud)
DllCall("DeleteObject", "Int", Brush_Player_1)
DllCall("DeleteObject", "Int", Brush_Player_1_Snowball_Velocity_Display)
DllCall("DeleteObject", "Int", Brush_Player_1_Snowball_Velocity_Display2)
DllCall("ReleaseDC", uint, hdcWin)
DllCall("ReleaseDC", uint, hdcMem)


Run_Time := A_TickCount - Start_Time
Run_Time /= 1000
Frame_Rate := Round(Frames / Run_Time)
MsgBox % "Total Frames : " . frames . "`r`nRun Time : " . Run_time . " seconds`r`nAvg Frame Rate : " . Frame_Rate . "`r`nSnowman Points : " . snowman_points . "`r`nSnowman Snowballs Thrown : " . snowman_snowballs_thrown


ExitApp
return

;###################################################################################################
;Snowball
;###################################################################################################
Player_1_Move_Arm:														; arm follows mouse direction
If (Player_1_Hit)
	return
MouseGetPos, mx, my
Player_1_Arm_Angle := atan2(Player_1_Y - my, mx - Player_1_X)
If (Player_1_Throwing < 2)
{
Player_1_Snowball_XP := Player_1_Snowball_X
Player_1_Snowball_YP := Player_1_Snowball_Y
Player_1_Snowball_X := Player_1_Arm_Radius * sin(Player_1_Arm_Angle) + Player_1_X
Player_1_Snowball_Y := Player_1_Y - Player_1_Arm_Radius * cos(Player_1_Arm_Angle)
Player_1_Hand_X := Player_1_Snowball_X
Player_1_Hand_Y := Player_1_Snowball_Y
DllCall("Ellipse", "Int", hdcMem, "Int", Player_1_Hand_X - Player_1_Snowball_Size / 2,"Int",Player_1_Hand_Y - Player_1_Snowball_Size / 2,"Int",Player_1_Hand_X + Player_1_Snowball_Size / 2,"Int",Player_1_Hand_Y + Player_1_Snowball_Size / 2)
}
return

;Player_1_Throwing:
;0 = Not throwing and no snowball airborne
;1 = Player started throwing motion by pressing the throw button (left mouse button by default)
;2 = Player has released the throw button, and snowball will be leaving their hand
;3 = Caluclating the angle, trajectory, etc of snowball
;4 = snowball is airborne
Player_1_Throw:												;detect start and end of throw
If (Player_1_Squatting)	or (Player_1_Hit)										; no throws while squatting
	return

if (GetKeyState(Player_1_Throw, "P")) && (!Player_1_Throwing)		; if player hold lbutton and wasnt prev throwing
	{
		Player_1_Throwing		:= 1
		Player_1_Throw_Start	:= a_tickcount
	}

Else if (GetKeyState(Player_1_Throw, "P")) && (Player_1_Throwing = 1)
	{	
		Player_1_Snowball_Velocity := A_TickCount - Player_1_Throw_Start ;if player is throwing, but hasnt realeased
		Player_1_Snowball_Velocity /= 10								 ;button yet.. 
		Player_1_Snowball_Velocity -= Player_1_Snowball_Size
		
		If (Player_1_Snowball_Velocity < 0)
				Player_1_Snowball_Velocity := 0
		If (Player_1_Snowball_Velocity > 200) 
				Player_1_Snowball_Velocity := 200
	}
Else if (!GetKeyState(Player_1_Throw, "P")) && (Player_1_Throwing = 1)		; if player is throwing, and releases lbutton
	{	
		Player_1_Snowball_Angle := Player_1_Arm_Angle * 57.29578
		if (Player_1_Snowball_Angle < 0)
			Player_1_Snowball_Angle +=360
		tempangle := Player_1_Snowball_Angle
		Player_1_Snowball_Angle := 90 - tempAngle
		theta := Player_1_Snowball_Angle * .01745329252
		vix := Player_1_Snowball_Velocity * cos(theta)
		viy := Player_1_Snowball_Velocity * sin(theta)
		ix := Player_1_Snowball_X
		iy := Player_1_Snowball_Y
		Player_1_Snowball_Y := iy
		Player_1_Snowball_X := ix
		ax	:= Wind_Speed
		ay	:= -9.80665
		ts := A_TickCount
		gy	:= A_ScreenHeight
		_moveto(hdcMem,ix,iy)
		Player_1_Throwing := 2
	}
Else If (Player_1_Throwing = 2)
	{
		Player_1_Snowball_XP := Player_1_Snowball_X
		Player_1_Snowball_YP := Player_1_Snowball_Y
		t := round((A_TickCount - ts)/1000,5)	* 6					; * playback speed
		Player_1_Snowball_Y := viy * t + .5 * ay * t**2
		Player_1_Snowball_Y := iy - Player_1_Snowball_Y
		Player_1_Snowball_X :=  vix * t + .5 * ax * t**2
		Player_1_Snowball_X += ix
		Player_1_Snowball_X_Offset 	:= Player_1_Snowball_X - Player_1_Snowball_XP
		Player_1_Snowball_Y_Offset	:= Player_1_Snowball_Y - Player_1_Snowball_YP
		DllCall("Ellipse", "Int", hdcMem, "Int", Player_1_Snowball_X,"Int",Player_1_Snowball_Y,"Int",Player_1_Snowball_X + Player_1_Snowball_Size,"Int",Player_1_Snowball_Y + Player_1_Snowball_Size)
		Gosub, Player_1_Check_for_Snowball_Collision
	}
return

Player_1_Create_New_Snowball:
Player_1_Snowball := DllCall("CreateEllipticRgn", "Int", Player_1_Snowball_X, "Int", Player_1_Snowball_Y, "Int", Player_1_Snowball_X + Player_1_Snowball_Size, "Int", Player_1_Snowball_Y + Player_1_Snowball_Size)
return

Player_1_Reset_Snowball:											;Create a new snowball
;gosub, Player_1_Move_Arm
Player_1_Snowball_Velocity := 0
Player_1_Throwing :=
Player_1_Snowball_Size := Player_1_Snowball_Size_Default
DllCall("DeleteObject", "Int", Player_1_Snowball)
gosub, Player_1_Move_Arm
return

;###################################################################################################
;Snowball Collisions
;###################################################################################################
Player_1_Check_for_Snowball_Collision:
If (Player_1_Snowball_Y > boardHeight)
		gosub, Player_1_Reset_Snowball

;if snowball hits the ground
Else If DllCall("PtInRegion", "Int", Landscape, "Int", Player_1_Snowball_X, "Int",Player_1_Snowball_Y +Player_1_Snowball_Size / 2)
	{
		gosub, Player_1_Create_New_Snowball
		DllCall("CombineRgn", "Int", Landscape, "Int", Player_1_Snowball, "Int", Landscape, "Int", 2)
		DllCall("DeleteObject", "Int", Player_1_Snowball)
		gosub, Player_1_Reset_Snowball
	}
	;if snowball hits the snowman
Else If DllCall("PtInRegion", "Int", Snowman, "Int", Player_1_Snowball_X + Player_1_Snowball_Size * .75 , "Int",Player_1_Snowball_Y + Player_1_Snowball_Size * .75)
	{
		gosub, Player_1_Create_New_Snowball
		DllCall("CombineRgn", "Int", Snowman, "Int",Snowman, "Int", Player_1_Snowball, "Int", RGN_DIFF)
		DllCall("DeleteObject", "Int", Player_1_Snowball)
		gosub, Player_1_Reset_Snowball
	}
return

Player_1_Snowball_Velocity_Display:
DllCall("SelectObject","UInt", hdcMem, "UInt", Brush_Player_1_Velocity_Snowball_Display2)
DllCall("SelectObject","UInt", hdcMem, "UInt", Pen_Hud)
DllCall("Rectangle", "Int", hdcMem, "Int", Player_1_Snowball_Velocity_Display_X, "Int", Player_1_Snowball_Velocity_Display_Y, "Int", Player_1_Snowball_Velocity_Display_X + 200, "Int", Player_1_Snowball_Velocity_Display_Y + Player_1_Snowball_Velocity_Display_Height)
DllCall("SelectObject","UInt", hdcMem, "UInt", Brush_Player_1_Velocity_Snowball_Display)
DllCall("Rectangle", "Int", hdcMem, "Int", Player_1_Snowball_Velocity_Display_X, "Int", Player_1_Snowball_Velocity_Display_Y, "Int", Player_1_Snowball_Velocity_Display_X + Player_1_Snowball_Velocity, "Int", Player_1_Snowball_Velocity_Display_Y + Player_1_Snowball_Velocity_Display_Height)
return

;###################################################################################################
;Update Screen
;###################################################################################################
Update_Screen:												; bitblt.. copy from bitmap to screen, and refill regions
If (Player_1_Hit)
	gosub, Player_1_Hit
else
	{
	;redraw players
	DllCall("SelectObject","UInt", hdcMem, "UInt", Pen_Player_1)
	DllCall("SelectObject","UInt", hdcMem, "UInt", Brush_Player_1)
	_MoveTo(hdcMem, Player_1_X, Player_1_Y+10)
	_LineTo(HdcMem, Player_1_Hand_X, Player_1_Hand_Y)
	;generic body
	_MoveTo(hdcMem, Player_1_X, Player_1_Y)
	_LineTo(hdcMem, Player_1_X, Player_1_Y + Player_1_Height)
	DllCall("Ellipse", "Int", hdcMem, "Int", Player_1_X - 10,"Int",Player_1_Y - 20,"Int",Player_1_X+10,"Int",Player_1_Y)
	}


;redraw snowballs
DllCall("FillRgn", "Int", hdcMem, "Int", Player_1_Snowball, "Int", Brush_Snowball)
;redraw snowman
gosub, snowman_draw

;redraw landscape
DllCall("FillRgn", "Int", hdcMem, "Int", Landscape, "Int", Brush_Landscape)
gosub, Player_1_Snowball_Velocity_Display

DllCall("BitBlt", "uint", hdcWin, "int", 0, "int", 0, "int", boardWidth, "int", boardHeight, "uint", hdcMem, "int", 0, "int", 0, "uint", 0xCC0020)
frames ++
If (Display_Frame_Rate)
	gosub, Display_Frame_Rate
return

Clear_Bitmap:												; Clear the bitmap in the hdcMem
DllCall("FillRect", "uint", hdcMem, "uint", &ptWin, "uint", Brush_BackGround)
return

;###################################################################################################
;Snowflakes
;###################################################################################################
Snowflakes_Animate:											; Makes the snowflakes fall from the top
DllCall("SelectObject","UInt", hdcMem, "UInt", Brush_Snowflake)
DllCall("SelectObject","UInt", hdcMem, "UInt", Pen_Snowflake)
gosub, Clear_Bitmap
Loop, %Snowflake_Count%
	{	
		SnowflakeY%A_Index% += SnowflakeS%A_Index%
		SnowflakeX%A_Index% += Wind_Speed
		DllCall("RoundRect", "Int", hdcMem, "Int", SnowflakeX%A_Index%, "Int", SnowflakeY%A_Index%, "Int", SnowflakeX%A_Index% + Snowflake_Size, "Int", SnowflakeY%A_Index% + Snowflake_Size, "Int", Snowflake_Size, "Int", Snowflake_Size)
		;if the snowflake hits the ground, goes below ground level, or goes off the edge of the screen while the wind is blowing toward that edge of the screen, replace that snowflake, as it will no longer be seen.
		If (DllCall("PtInRegion", "int",landscape, "int", SnowflakeX%A_Index%, "int", SnowflakeY%A_Index%))or (SnowflakeY%A_Index% >= boardheight)or if (SnowflakeX%A_Index% < 0 && Wind_Speed < 0) or If (SnowflakeX%A_index% > boardWidth && Wind_Speed > 0)
				_Snowflake(SnowflakeX%A_Index%, SnowflakeY%A_Index%, SnowflakeS%A_Index%,Wind_Speed)
	}
return
;###################################################################################################
;wind
;###################################################################################################
Change_Wind:															;Changes the wind speed(and/or direction)
If (A_TickCount - Wind_Change_Time > Wind_Change_Rate) or (!Wind_Change_Time)
	{
		Wind_Speed := rnd(-Wind_Maximum_Speed,Wind_Maximum_Speed)
		Wind_Change_Time := A_TickCount
		;SoundSetWaveVolume, 50 + Wind_Speed * 5
		;SoundPlay("wind-.mp3", "multi")
	}
return

;###################################################################################################
;Setup
;###################################################################################################
Initialize_Color_Values:													;Assigns color names to BGR value
Green		:= "0x008000"
Silver		:= "0xC0C0C0"
Lime		:= "0x00FF00"
Gray		:= "0x808080"
Olive		:= "0x008080" 
White		:= "0xFFFFFF"
Yellow		:= "0x00FFFF"
Maroon		:= "0x000080"
Navy		:= "0x800000"
Red			:= "0x0000FF"
Blue		:= "0xFF0000"
Purple		:= "0x800080"
Teal		:= "0x808000" 
Fuchsia		:= "0xFF00FF"
Aqua		:= "0xFFFF00"
Black		:= "0x000000"
Brown		:= "0x2A2AA5" 

RGN_AND		:= 1
RGN_COPY 	:= 5
RGN_DIFF 	:= 4
RGN_OR		:= 2
RGN_XOR		:= 3
return

Initialize_Variables:													;Sets the initial game variables
;Landscape
Landscape_X_Position		:= -100
Landscape_Y_Position		:= boardHeight - 200
Landscape_Width				:= boardWidth + 100
Landscape_Height			:= boardHeight + 100
;Landscape_Elevation_Minimum	:= boardHeight - 50							;The lowest the Landscape can be
;Landscape_Elevation_Maximum	:= boardHeight - 500						;The highest the Landscape can be
Landscape_Color				:= White									;The color of the Landscape
;Landscape_Flatness			:= 75									;How flat the Landscape is (100 is flat, 0 is hilly)

;snowfall
Snowflake_Count				:= 300										;The number of Snowflakes falling
Snowflake_Size				:= 3										;The size of the Snowflakes
SnowFall_Accumulation_On	:= 1										;Does the snow accumulate (1 on, 0 off)
SnowFall_Accumulation_Rate	:= 60000									;How often the snow gets deeper (milliseconds)

;snowball
Player_1_Snowball_Size_Default := 0
Player_1_Snowball_Size		:= Player_1_Snowball_Size_Default
Player_1_Snowball_X			:= 100
Player_1_Snowball_Y			:= 100
Snowman_Snowball_Size_Default := 130
Snowman_Snowball_Size		:= Snowman_Snowball_Size_Default
Snowman_Snowball_X			:= Snowman_Torso_X - 10
Snowman_Snowball_Y			:= Snowman_Torso_Y - 10
Player_1_Snowball_Velocity 	:= 0
Snowball_Splash_Width		:= 20
Snowball_Splash_Height		:= 10
Snowball_Splash_Amount		:= 25

;wind
Wind_On						:= 1										;Is there wind (1 on, 0 off)
Wind_Speed					:= 0										;The current speed of the wind
;Wind_Minimum_Speed			:= 1										;The minimum wind speed
Wind_Maximum_Speed			:= 6										;The maximum wind speed
Wind_Change_Rate			:= 50000									;How often the wind changes (milliseconds)
Wind_Change_Time 			:= 

;sound
Sound_Effects_On			:= 1										;Play sound effects (1 on, 0 off)
Sound_Effects_Volume		:= 50										;Volume of the sound effects (0 mute, 100 max)
Wind_Sound_On				:= 1										;Play background wind noise (1 on, 0 off)
Wind_Sound_Volume			:= 40										;Volume of the wind sound (0 mute, 100 max)
R_Rated_Sounds				:= 1										;Play the R rated sound effects (swearing)

;player
Player_1_Color				:= Red										;The color of player one (on left)
Player_1_X					:= 200
Player_1_Y					:= boardHeight -258
Player_1_Arm_Radius			:= 50
Player_1_Walk_Speed			:= 3
Player_1_Run_Speed			:= 5
Player_1_Height_Default		:= 100
Player_1_Height				:= Player_1_Height_Default
Player_1_Jump_Height		:= 150


;Controls
Player_1_Throw				:= "LButton"
Player_1_Right				:= "D"
Player_1_Left				:= "A"
Player_1_Down				:= "S"
Player_1_Up					:= "W"
Player_1_Jump				:= "Space"
Toggle_Frame_Rate			:= "F1"
Toggle_Auto_Adjust_FPS		:= "F2"
Snowflake_More				:= "F3"
Snowflake_Less				:= "F4"
Player_1_Controls := "Player_1_Right,Player_1_Left,Player_1_Down,Player_1_Up,Player_1_Jump,Toggle_Frame_Rate,Player_1_Throw,Toggle_Auto_Adjust_FPS,Snowflake_More,Snowflake_Less"

;Hud
;Velocity Bar
Player_1_Snowball_Velocity_Display_X := 10
Player_1_Snowball_Velocity_Display_Y := 10
Player_1_Snowball_Velocity_Display_Height := 20
Player_1_Snowball_Velocity_Display_Color := Red

;Snowman
Snowman_Base_X				:= boardWidth - 200
Snowman_Base_Y				:= boardHeight - 300
Snowman_Base_Size			:= 200
Snowman_Torso_X				:= Snowman_Base_X + 25
Snowman_Torso_Size			:= Snowman_Base_Size * .65
Snowman_Torso_Y				:= Snowman_Base_Y - Snowman_Torso_Size + 50
Snowman_Head_X				:= Snowman_Torso_X + 25
Snowman_Head_Size			:= Snowman_Torso_Size * .65
Snowman_Head_Y				:= Snowman_Torso_Y - Snowman_Head_Size + 25
Snowman_Color				:= White
Snowman_Arm_X				:= Snowman_Torso_X + Snowman_Torso_Size / 2
Snowman_Arm_Y				:= Snowman_Torso_Y + Snowman_Torso_Size / 2
Snowman_Hand_X				:= Snowman_Torso_X - 10
Snowman_Hand_Y				:= Snowman_Torso_Y - 10
Snowman_Arm_Color			:= Brown
Snowman_Arm_Thickness		:= 5
Snowman_X := Snowman_Base_X + Snowman_Base_Size / 2			; X is middle of base on snowman
Snowman_Y := Snowman_Base_Y + Snowman_Base_Size / 2	

;Performance
Frame_Rate_Auto_Adjust		:= 1										;Makes game adjustments if low frame rate.
return

Initialize_Graphics:
;device contexts
VarSetCapacity(ptWin, 16, 0)
NumPut(boardWidth, ptWin, 8) , NumPut(boardHeight, ptWin, 12)
gui,1: color, black
gui,show, h%BoardHeight% w%BoardWidth% x-3 y-22
hdcWin := DllCall("GetDC", "UInt", hwnd:=WinExist("A"))					;Get device context of current window
hdcMem := DllCall("CreateCompatibleDC", "UInt", hdcWin)					;Create a device context in memory

;bitmaps
hbm := DllCall("CreateCompatibleBitmap", "uint", hdcWin, "int", boardWidth, "int", boardHeight)	;create bitmap
DllCall("SelectObject", "uint", hdcMem, "uint", hbm)											;select it to memory dc

;pens
Pen := DllCall("CreatePen", "UInt", 0, "UInt", Ground_Pen_Width, "UInt", Ground_Color)
DllCall("SelectObject","UInt", hdcMem, "UInt", Pen)
Pen_Player_1 := DllCall("CreatePen", "UInt", 0, "UInt", 5, "UInt", Player_1_Color)
Pen_Snowflake := DllCall("CreatePen", "UInt", 0, "UInt", Snowflake_Size, "UInt", White)
Pen_Snowball := DllCall("CreatePen", "UInt", 0, "UInt", Player_1_Snowball_Size, "Int", White)
Pen_Hud := DllCall("CreatePen", "UInt", 0, "UInt", 1, "Int", White)
Pen_Snowman_Arms := DllCall("CreatePen", "UInt", 0, "UInt", Snowman_Arm_Thickness, "Int", Snowman_Arm_Color)
Pen_Snowman_Legs := DllCall("CreatePen", "UInt", 0, "UInt", 62, "Int", White)
Pen_Snowman_Foot := DllCall("CreatePen", "UInt", 0, "UInt", 42, "Int", Gray)
;brushes
Brush_BackGround := DllCall("CreateSolidBrush", "Int", Black)
Brush_Snowflake := DllCall("CreateSolidBrush", "Int", White)
Brush_Snowball := DllCall("CreateSolidBrush", "Int", White)
Brush_Snowman_Snowball := DllCall("CreateSolidBrush", "Int", White)
Brush_Snowman := DllCall("CreateSolidBrush", "Int", Snowman_Color)
Brush_Landscape := DllCall("CreateSolidBrush", "Int", White)
Brush_Hud		:= DllCall("CreateSolidBrush", "Int", Red)
Brush_Player_1		:= DllCall("CreateSolidBrush", "Int", Red)
Brush_Player_1_Velocity_Snowball_Display := DllCall("CreateSolidBrush", "Int", Player_1_Snowball_Velocity_Display_Color)
Brush_Player_1_Velocity_Snowball_Display2 := DllCall("CreateSolidBrush", "Int", Gray)
;text
DllCall("SetTextColor", "int", hdcMem, "int", blue)
return

Initialize_Snowflakes:													;Creates the array of Snowflakes
Loop, %Snowflake_Count%
	_Snowflake(SnowflakeX%A_Index%, SnowflakeY%A_Index%, SnowflakeS%A_Index%,Wind_Speed)
return

Initialize_Landscape:												;Set the shape of the ground
Landscape := DllCall("CreateEllipticRgn", "Int", Landscape_X_Position, "Int", Landscape_Y_Position, "Int", Landscape_Width, "Int", Landscape_Height)
;Landscape := DllCall("CreateRectRgn", "Int", Landscape_X_Position, "Int", Landscape_Y_Position, "Int", boardwidth, "Int", boardheight)
return

Initialize_Player_Regions:
;Player_1_Snowball := DllCall("CreateEllipticRgn", "Int", Player_1_Snowball_X, "Int", Player_1_Snowball_Y, "Int", Player_1_Snowball_X + Player_1_Snowball_Size, "Int", Player_1_Snowball_Y + Player_1_Snowball_Size)
return

Initialize_SnowMan_Regions:
SnowMan_Base := DllCall("CreateEllipticRgn", "Int", Snowman_Base_X, "Int", Snowman_Base_Y, "Int", Snowman_Base_X + Snowman_Base_Size, "Int", Snowman_Base_Y + Snowman_Base_Size)
SnowMan_Torso := DllCall("CreateEllipticRgn", "Int", Snowman_Torso_X, "Int", Snowman_Torso_Y, "Int", Snowman_Torso_X + Snowman_Torso_Size, "Int", Snowman_Torso_Y + Snowman_Torso_Size)
SnowMan_Head := DllCall("CreateEllipticRgn", "Int", Snowman_Head_X, "Int", Snowman_Head_Y, "Int", Snowman_Head_X + Snowman_Head_Size, "Int", Snowman_Head_Y + Snowman_Head_Size)
Snowman := DllCall("CreateEllipticRgn","Int",0,"Int",0,"Int",0,"Int",0)
DllCall("CombineRgn", "Int", Snowman, "Int", Snowman_Base, "Int", Snowman_Torso, "Int", RGN_OR)
DllCall("CombineRgn", "Int", Snowman, "Int", Snowman, "Int", Snowman_Head, "Int", RGN_OR)
DllCall("DeleteObject", "Int", Snowman_Base)
DllCall("DeleteObject", "Int", Snowman_Torso)
DllCall("DeleteObject", "Int", Snowman_Head)
return

Initialize_HUD:
return

;###################################################################################################
;Functions
;###################################################################################################
rnd(min,max){															;Generate random number
random, temp, %min%, %max%
return, temp
}

_Snowflake(byref nameX, ByRef nameY, ByRef nameS,Wind_Speed)	;Generates Snowflake array
	{
		if (Wind_Speed < 0)				;wind blowing right to left
			leftbound := A_ScreenWidth / 2, rightbound := A_ScreenWidth + 500
		else
			leftbound := -300, rightbound := A_ScreenWidth	;wind blowing left to right
		Random, x, leftbound,rightbound
		if (x < 0) or (x > 1920)
			Random, y, 0,1080
		else
			Random, y, 0, -1500
		Random, s, .3,3.0
		nameX := X
		nameY := Y
		nameS := S
	}
	
_MoveTo(dc,endx,endy){
	Return DllCall("MoveToEx",uint, dc, int, endx, int, endy)
}
_LineTo(dc,endx,endy){
	Return DllCall("LineTo",uint, dc, int, endx, int, endy)
}

atan2(x,y) { 
   Return dllcall("msvcrt\atan2","Double",y, "Double",x, "CDECL Double") 
} 

SoundPlay(Filename, wait="") { 
static pSoundPlay=0, File=0 
  if !(pSoundPlay) 
    pSoundPlay := RegisterCallback( "SoundPlay" ) 
  if !(Filename=0xFFFF) 
    File := Filename 
  if (wait="Multi") or (wait>=2) 
    DllCall( "CreateThread", UInt,0, UInt,0, UInt,pSoundPlay, UInt,0xFFFF, UInt,0, UInt,0 ) 
  else 
    SoundPlay, %File%, %wait% 
return 
}