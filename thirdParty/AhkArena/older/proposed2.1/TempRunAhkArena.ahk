IsTempRunFile:=true
player1=Lagos
player2=Morpha
#NoEnv
#SINGLEINSTANCE force
Gui, color, 0xE5DDCF, 0xE5DDCF

if NOT IsTempRunFile
	{
        TempAhkFileName=TempRunAhkArena.ahk
        FileDelete, %TempAhkFileName%
	Loop, player_*.ahk
           FileList = %FileList%%A_LoopFileName%|
	If !FileList
		{
		MsgBox,48, Error, No Player Scripts found. Please make sure your Player Scripts are located in the same directory as your game platform and are named correctly!
		ExitApp
		}
	Gui, 3:Add, DropDownList, vChoicePlayer1, %FileList%
	Gui, 3:Add, Button, Default, OK
	Gui, 3:Show,, Player 1?
	WinWaitClose, Player 1? ahk_class AutoHotkeyGUI
	Gui, 4:Add, DropDownList, vChoicePlayer2, %FileList%
	Gui, 4:Add, Button, Default, OK
	Gui, 4:Add, Text,, Player 1 = %choiceplayer1%
	Gui, 4:Show,, Player 2?
	WinWaitClose, Player 2? ahk_class AutoHotkeyGUI
	If ChoicePlayer1 = %ChoicePlayer2%
		{
		MsgBox,48, Error, Player1's and Player2's scripts cannot be the same!
		ExitApp
		}
	IfExist, %ChoicePlayer1%
		{
		SplitPath, ChoicePlayer1,,,, OutNameNoExt1
		StringTrimLeft, Nameplayer1, OutNameNoExt1, 7
		}
	Else
		{
		MsgBox,48, Error, Player1's Script not found!
		ExitApp
		}
	IfExist, %ChoicePlayer2%
		{
		SplitPath, ChoicePlayer2,,,, OutNameNoExt2
		StringTrimLeft, Nameplayer2, OutNameNoExt2, 7
		}
	Else
		{
		MsgBox,48, Error, Player2's Script not found!
		ExitApp
		}
        FileAppend, IsTempRunFile:=true, %TempAhkFileName%
        FileAppend, `nplayer1=%NamePlayer1%, %TempAhkFileName%
        FileAppend, `nplayer2=%NamePlayer2%, %TempAhkFileName%
        Loop, read, %A_ScriptFullPath%
                FileAppend, `n%A_LoopReadLine%, %TempAhkFileName%
        Loop, read, %ChoicePlayer1%
        {
                if RegExMatch(A_LoopReadLine, "(Script\(\)\{|Class\d:)")
                        FileAppend, `n%NamePlayer1%%A_LoopReadLine%, %TempAhkFileName%
                else if RegExMatch(A_LoopReadLine, "Gosub, .*Class%2currentclass%")
                        FileAppend, `nGosub`, %NamePlayer1%Class`%2currentclass`%, %TempAhkFileName%
                else
                        FileAppend, `n%A_LoopReadLine%, %TempAhkFileName%
        }
        Loop, read, %ChoicePlayer2%
        {
                if RegExMatch(A_LoopReadLine, "(Script\(\)\{|Class\d:)")
                        FileAppend, `n%NamePlayer2%%A_LoopReadLine%, %TempAhkFileName%
                else if RegExMatch(A_LoopReadLine, "Gosub, .*Class%1currentclass%")
                        FileAppend, `nGosub`, %NamePlayer2%Class`%1currentclass`%, %TempAhkFileName%
                else
                        FileAppend, `n%A_LoopReadLine%, %TempAhkFileName%
        }
        Run, %TempAhkFileName%
        ExitApp
	;Run "%A_AhkPath%" /restart "%A_ScriptFullPath%" "%Nameplayer1%" "%Nameplayer2%"
	;sleep 10000
	}

If (!pToken := Gdip_Startup()){
  MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system!
  ExitApp
}
SetFormat, float, 0.0

InputBox, gamecount, Number of games?, Games will automatically continue until the number of games chosen have been played.,,
%player1% := 1
%player2% := 2
%player1%enemy := player2
%player2%enemy := player1
%player1%gamewins = 0
%player2%gamewins = 0
Gui, Add, Text, x516 y147 w110 h20 cFF9900, %player1% - Player 1
Gui, Add, Text, x516 y287 w110 h20 c663399, %player2% - Player 2
Gui, Add, Text, x516 y167 w110 h120 vp1text, % "Units = " . %player1%unitcount . "`nKills = " . %player1%kills . "`nResources = " . %player1%resources . "`nGames won = " . %player1%gamewins . "`nWin Percent = " . %player1%winpercent . "%`nTotal Units = " . %player1%totalunitcount . "`nTotal Kills = " . %player1%totalkills . "`nTotal Resources = " . %player1%totalresources
Gui, Add, Text, x516 y307 w110 h120 vp2text, % "Units = " . %player2%unitcount . "`nKills = " . %player2%kills . "`nResources = " . %player2%resources . "`nGames won = " . %player2%gamewins . "`nWin Percent = " . %player2%winpercent . "%`nTotal Units = " . %player2%totalunitcount . "`nTotal Kills = " . %player2%totalkills . "`nTotal Resources = " . %player2%totalresources
Gui, Add, Text, x526 y7 w90 h70 vmaintext, MainText
Gui, Add, Text, x536 y437 w70 h20, Game Speed
Gui, Add, Slider, x516 y457 w110 h30 vSpeedSlider Range1-400 tooltip invert, 200
Gui, Add, Button, x526 y97 w90 h20, Start
Gui, Add, Button, x526 y117 w90 h20, Pause
; Generated using SmartGUI Creator 4.0
Gui, Show, x124 y78 h507 w640, AHK Arena


HWND := WinExist("A")                                       ; Get the HWND of our Window
; ++++++  GDI Stuff starts here +++++++++
hdc_WINDOW      := GetDC(HWND)                              ; MASTER DC on our Window
hbm_main := CreateDIBSection(502, 502)              ; 502 x 502 is the size of our GDI image
hdc_main := CreateCompatibleDC()
obm      := SelectObject(hdc_main, hbm_main)
G        := Gdip_GraphicsFromHDC(hdc_main)          ; Getting a Pointer to our bitmap
;some brushes
   pBWHITE              := Gdip_BrushCreateSolid(0xffFFFFFF)
   pBBLACK              := Gdip_BrushCreateSolid(0xff000000)
   pBGrey55				:= Gdip_BrushCreateSolid(0x55333333)
   pBGREEN55			:= Gdip_BrushCreateSolid(0x5500FF00)
   pBPURPLE				:= Gdip_BrushCreateSolid(0xff663399)
   pBPURPLE55			:= Gdip_BrushCreateSolid(0x55663399)
   pBYELLOW				:= Gdip_BrushCreateSolid(0xffFFFF00)
   pBYellowOrange		:= Gdip_BrushCreateSolid(0xffFF6600)
   pBORANGE				:= Gdip_BrushCreateSolid(0xffFF9900)
   pBORANGE55			:= Gdip_BrushCreateSolid(0x55FF9900)
   pBBLUESCAN			:= Gdip_BrushCreateSolid(0x500000FF)
   pPLGREEN				:= Gdip_CreatePen(0xff33FF33, 1)
   pPGREEN				:= Gdip_CreatePen(0xff00FF00, 1)
   pPGREY				:= Gdip_CreatePen(0xff666666, 4)
   pPHotPink			:= Gdip_CreatePen(0xffFF3399, 2)
   pPBLACK				:= Gdip_CreatePen(0xff000000, 1)
   pPRed				:= Gdip_CreatePen(0xffFF0000, 1)
   pPDarkGreyTHICK		:= Gdip_CreatePen(0xff333333, 3)
   pPYellow3			:= Gdip_CreatePen(0xffFFFF00, 3)
   pPYellow				:= Gdip_CreatePen(0xffFFFF00, 2)
   pBLblue				:= Gdip_BrushCreateSolid(0xff3333FF)
; Now we draw on our Frame:
Gdip_FillRectangle(G,pBWHITE,0,0,500,500)    ;white background
; ++++++  GDI Stuff ends here +++++++++

gosub, setup ;new game setup subroutine
return

3GuiClose:
ExitApp

3ButtonOK:
Gui, 3:Submit
Return

4GuiClose:
ExitApp

4ButtonOK:
Gui, 4:Submit
Return

;--------------------------------------------------------------------------------------------------
;-----------------------------------------Main Game Loop Start-------------------------------------
;--------------------------------------------------------------------------------------------------
buttonstart:
Gui, Submit, NoHide
Loop %gamecount%
	{
	Loop
		{
		Sleep %SpeedSlider%
		turncount := a_index
		Guicontrol, Text, maintext, MainText`nGame = %gamenumber%`nTurn = %a_index%`nAvg. # Turns: %turnaverage%
		IF (gofirst = 1)
			Player1script() ; execute player 1's script
		Else IF (gofirst = 2)
			Player2script()
		Sleep %SpeedSlider%
		AA_Refresh() ; deletes animations, redraws board and all units.
		IF (gofirst = 1)
			%player2%script() ; execute player 1's script
		Else IF (gofirst = 2)
			%player1%script()
		Sleep %SpeedSlider%
		AA_Refresh() ; deletes animations, redraws board and all units.
		AA_endturn() ; change cooldowns, spawn new mineral, check for winner
		If (play = 0)
			{
			SetTimer, closewindow, -6000
			gosub, setup ;if game ends, start a new game.
			break
			}
		}
	}
return
;--------------------------------------------------------------------------------------------------
;-----------------------------------------Main Game Loop End---------------------------------------
;--------------------------------------------------------------------------------------------------


setup:
FileDelete, allunitlist.txt
play = 1
gamenumber += 1
unitID = 0
Random, gofirst, 1, 2
%player1%kills = 0
%player2%kills = 0
%player1%unitcount = 0
%player2%unitcount = 0
%player1%resources = 0
%player2%resources = 0
stalematecheck1old =
stalematecheck2old =
Loop 9
	{
	%Player1%Class%a_index%unitcount = 0
	%Player2%Class%a_index%unitcount = 0
	}
mineralcurrent = 0
drawvarY = 0
drawvarX = 0
Loop 25
{
Gdip_DrawLine(G, pPBLACK, drawvarY,0,drawvarY,500)
Gdip_DrawLine(G, pPBLACK, 0,drawvarX,500,drawvarX)    ;lines
drawvarY += 20
drawvarX += 20
}
Loop 15
	mineral%a_index%value = 0
Loop 15 ;spawn starting mineral
	AA_SpawnMineral()
AA_Spawn()
%Player1%Resources = 6
%Player2%Resources = 6
return

Buttonpause:
Pause = 1
return

GuiClose:
ExitApp

closewindow:
Gui, 2:Destroy
return

;--------------------------------------------------------------------------------------------------
;-----------------------------------------Game Functions Start Here!-------------------------------
;--------------------------------------------------------------------------------------------------
AA_Spawn()
{
global
;player 1
%player1%unitcount += 1
%player1%totalunitcount += 1
%player1%class1unitcount += 1
unitID += 1
newunit = %player1%_1_%unitID%
%newunit%_posx = 241
%newunit%_posy = 61
%newunit%_cooldown = 1
%newunit%_attack = 1
%newunit%_move = 1
%newunit%_gather = 1
%newunit%_scan = 1
%newunit%_build = 1
%newunit%_hp = 4
%newunit%_visible = 0
%newunit%_class := 1
%newunit%_type = 111114
FileAppend, %newunit%|, AllUnitlist.txt
AA_DrawUnit(newunit)
;player 2
%player2%unitcount += 1
%player2%totalunitcount += 1
%player2%class1unitcount += 1
unitID += 1
newunit = %player2%_1_%unitID%
%newunit%_posx = 241
%newunit%_posy = 421
%newunit%_cooldown = 1
%newunit%_attack = 1
%newunit%_move = 1
%newunit%_gather = 1
%newunit%_scan = 1
%newunit%_build = 1
%newunit%_hp = 4
%newunit%_visible = 0
%newunit%_class := 1
%newunit%_type = 111114
FileAppend, %newunit%|, AllUnitlist.txt
AA_DrawUnit(newunit)
return
}

AA_Build(stats, CreatingUnit, Class, Direction = "A") ; example: AA_Build(101110, "2_1_1", 1, "L")
{ 														; 1move, 2build, 3scan, 4attack, 5gather, 6hp
global
If (%creatingunit%_build = 0)
	return 0
If (%creatingunit%_cooldown > 0)
	return 3
stringsplit, stats, stats
Cost := stats1+stats2+stats3+stats4+stats5+stats6
If (Cost > 4)
	return
StringGetPos, Position, CreatingUnit, _
StringLeft, player, CreatingUnit, Position
If (%player%resources < Cost)
	return 4
If (direction = "UR")
	{
	xvalue = 20
	yvalue = -20
	}
If (direction = "UL")
	{
	xvalue = -20
	yvalue = -20
	}
If (direction = "DR")
	{
	xvalue = 20
	yvalue = 20
	}
If (direction = "DL")
	{
	xvalue = -20
	yvalue = 20
	}
If (direction = "U")
	{
	xvalue = 0
	yvalue = -20
	}
If (direction = "D")
	{
	xvalue = 0
	yvalue = 20
	}
If (direction = "L")
	{
	xvalue = -20
	yvalue = 0
	}
If (direction = "R")
	{
	xvalue = 20
	yvalue = 0
	}
If (direction = "A")
	{
	x1 = 20
	x2 = 0
	x3 = -20
	y1 = 0
	y2 = 20
	y3 = -20
	anyloop = 0
	Loop 3
		{
		anyloop += 1
		Loop 3
			{
			xvalue := x%anyloop%
			yvalue := y%a_index%
			checkx := %creatingunit%_posx+xvalue
			checky := %creatingunit%_posy+yvalue
			If AA_CheckOccupancy(checkx, checky) = 0
				break
			}
		If AA_CheckOccupancy(checkx, checky) = 0
			break
		}
	}
checkx := %creatingunit%_posx+xvalue
checky := %creatingunit%_posy+yvalue
If AA_CheckOccupancy(checkx, checky) = 1
	return 5
%player%unitcount += 1
%player%totalunitcount += 1
%player%class%class%unitcount += 1
unitID += 1
newunit = %player%_%class%_%unitID%
%newunit%_posx := %creatingunit%_posx+xvalue
%newunit%_posy := %creatingunit%_posy+yvalue
%newunit%_cooldown = 1
%newunit%_attack := stats4
%newunit%_move := stats1
%newunit%_gather := stats5
%newunit%_scan := stats3
%newunit%_build := stats2
%newunit%_hp := (1 + stats6)
%newunit%_visible = 0
%newunit%_class := class
%newunit%_type := stats
builddivide := %creatingunit%_build
%creatingunit%_cooldown += 15/builddivide
FileAppend, %newunit%|, AllUnitlist.txt
%player%resources -= %cost%
AA_DrawUnit(newunit)
Guicontrol, Text, p1text, % "Units = " . %player1%unitcount . "`nKills = " . %player1%kills . "`nResources = " . %player1%resources . "`nGames won = " . %player1%gamewins . "`nWin Percent = " . %player1%winpercent . "%`nTotal Units = " . %player1%totalunitcount . "`nTotal Kills = " . %player1%totalkills . "`nTotal Resources = " . %player1%totalresources
Guicontrol, Text, p2text, % "Units = " . %player2%unitcount . "`nKills = " . %player2%kills . "`nResources = " . %player2%resources . "`nGames won = " . %player2%gamewins . "`nWin Percent = " . %player2%winpercent . "%`nTotal Units = " . %player2%totalunitcount . "`nTotal Kills = " . %player2%totalkills . "`nTotal Resources = " . %player2%totalresources
return
}

AA_Move(Unit, Direction) ; ("1_1_1", "U") See below for potential directions.
{
	global
	If (%unit%_move = 0)
		return 0
	If (%unit%_cooldown > 0)
		return 3
	If (direction = "UR" OR direction = "RU")
	{
		xvalue = 20
		yvalue = -20
	}
	If (direction = "UL" OR direction = "LU")
	{
		xvalue = -20
		yvalue = -20
	}
	If (direction = "DR" OR direction = "RD")
	{
		xvalue = 20
		yvalue = 20
	}
	If (direction = "DL" OR direction = "LD")
	{
		xvalue = -20
		yvalue = 20
	}
	If (direction = "U")
	{
		xvalue = 0
		yvalue = -20
	}
	If (direction = "D")
	{
		xvalue = 0
		yvalue = 20
	}
	If (direction = "L")
	{
		xvalue = -20
		yvalue = 0
	}
	If (direction = "R")
	{
		xvalue = 20
		yvalue = 0
	}
	movex := %unit%_posx + xvalue
	movey := %unit%_posy + yvalue
	occupancycheck := AA_CheckOccupancy(movex, movey)
	If (OccupancyCheck = 1)
		return	5
	Gdip_SetSmoothingMode(G, 1)   ; turn off aliasing
   	Gdip_SetCompositingMode(G, 1) ; set to overdraw
   	; delete previous graphic and redraw background
	Gdip_FillRectangle(G, pBWHITE, %unit%_posx, %unit%_posy, 19, 19)
	Gdip_SetCompositingMode(G, 0) ; switch off overdraw
	%unit%_posx += %xvalue%
	%unit%_posy += %yvalue%
	AA_DrawUnit(unit)
	%unit%_cooldown += 1
	return
}

AA_Scan(Unit) ; ("1_1_1") the unit that is performing the scan
{
global
mainloop = 0
If (%unit%_scan = 0) ;check if scanning unit has scan function module
	return 0
If (%unit%_cooldown > 0) ;check cooldown
	return 3
StringGetPos, Position, Unit, _
StringLeft, scanningplayer, Unit, Position
targetplayer := %scanningplayer%enemy
FileRead, AllUnits, AllUnitList.txt ;scan units routine
StringSplit, unit, AllUnits, |
refreshloop := unit0-1
Loop %refreshloop%
	{
	scanunit := unit%a_index%
	StringGetPos, Position, scanUnit, _
	StringLeft, player, scanUnit, Position
	If (player = scanningplayer)
		Continue
	xscandistance := abs(%scanunit%_posx - %unit%_posx)
	yscandistance := abs(%scanunit%_posy - %unit%_posy)
	scanrange := %unit%_scan*20
	If (xscandistance <= scanrange) AND (yscandistance <= scanrange)
		%scanunit%_visible = 1
	}
Loop 15 ;scan minerals routine
	{
	If mineral%a_index%value >= 1 ;if a mineral has value > 1
		{
		target = mineral%a_index%
		xscandistance := abs(%target%x - %unit%_posx)
		yscandistance := abs(%Target%y - %unit%_posy)
		If (xscandistance <= scanrange) AND (yscandistance <= scanrange)
			%target%visible = 1
		}
	}
scananimationx := %unit%_posx-scanrange
scananimationy := %unit%_posy-scanrange
scananimationwh := scanrange*2+20
Gdip_SetSmoothingMode(G, 4)
Gdip_FillEllipse(G,pBBLUESCAN, scananimationx, scananimationy, scananimationwh, scananimationwh)
%unit%_cooldown += 1
mainloop = 0
BitBlt(hdc_WINDOW,0, 0, 502,502, hdc_main,0,0) ;position of the GDI Image in the GUI
return
}

AA_Refresh()
{
global
refreshloop = 0
Gdip_FillRectangle(G,pBWHITE,0,0,500,500)    ;white background
drawvarY = 0
drawvarX = 0
Loop 25
	{
	Gdip_DrawLine(G, pPBLACK, drawvarY,0,drawvarY,500)
	Gdip_DrawLine(G, pPBLACK, 0,drawvarX,500,drawvarX)    ;gridlines
	drawvarY += 20
	drawvarX += 20
	}
Loop 15 ;draw minerals
	{
	If mineral%a_index%value = 0
		continue
	mindrawx := mineral%a_index%x
	mindrawy := mineral%a_index%y
	minsize := mineral%a_index%value
	size := minsize*4
	If (minsize = 0)
		continue
	munitvis := mineral%a_index%visible
	if (munitvis = 0)
		minbrush = pBGREY55
	Else if (munitvis = 1)
		minbrush = pBGREEN55
	Gdip_FillEllipse(G,%minbrush%, mindrawx, mindrawy, size, size)
	}

FileRead, AllUnits, AllUnitList.txt
StringSplit, unit, AllUnits, |
refreshloop := unit0-1
Loop %refreshloop% ;draw units
	{
	refreshunit := unit%a_index%
	AA_DrawUnit(refreshunit)
	}
If (pause = 1)
	{
	msgbox, Press OK to unpause the game.
	pause = 0
	}
return
}

AA_Attack(Unit, Target) ; ("1_1_1", "2_1_1")
{
global
If (%unit%_attack = 0) ;check if scanning unit has attack function module
	return 0
If (%unit%_cooldown > 0) ;check cooldown
	return 3
If (%target%_hp < 1)
	return
xattackdistance := abs(%target%_posx - %unit%_posx)
yattackdistance := abs(%Target%_posy - %unit%_posy)
attackrange := %unit%_attack*20
If (xattackdistance <= attackrange) AND (yattackdistance <= attackrange) ;check if target is in range
	{
	If (%target%_visible = 0) ;check if target has been scanned yet
		return 4
	%Target%_hp -= 1
	attackanimationx1 := %unit%_posx+10
	attackanimationy1 := %unit%_posy+10
	attackanimationx2 := %target%_posx+10
	attackanimationy2 := %target%_posy+10
	attackstar1x := %target%_posx+5
	attackstar1y := %target%_posy+15
	attackstar2x := %target%_posx+10
	attackstar2y := %target%_posy+3
	attackstar3x := %target%_posx+15
	attackstar3y := %target%_posy+15
	attackstar4x := %target%_posx+3
	attackstar4y := %target%_posy+7
	attackstar5x := %target%_posx+17
	attackstar5y := %target%_posy+7
	attackstar6x := %target%_posx+5
	attackstar6y := %target%_posy+15
	Gdip_SetSmoothingMode(G, 4)
	Gdip_DrawLine(G, pPYELLOW, attackanimationx1,attackanimationy1,attackanimationx2,attackanimationy2)
	Loop 5
		{
		point2 := a_index+1
		Gdip_DrawLine(G, pPRED, attackstar%a_index%x,attackstar%a_index%y,attackstar%point2%x,attackstar%point2%y)
		}
	Font = Arial
	textx := attackanimationx2+5
	texty := attackanimationy2-10
	Options = x%textx% y%texty% 0xffFF0000 s9
	Gdip_TextToGraphics(G, "-1 hp", Options, Font)
	%unit%_cooldown += 1
	StringGetPos, Position, unit, _
	StringLeft, attackingplayer, unit, Position
	mainloop = 0
	BitBlt(hdc_WINDOW,0, 0, 502,502, hdc_main,0,0) ;position of the GDI Image in the GUI
	If (%target%_hp < 1) ;If target destroyed
		{
		StringGetPos, Position, target, _
		StringLeft, deadplayer, target, Position
		DeathStar = -5,-5,8,7|10,-10,10,5|23,-5,13,8|15,10,25,10|12,13,23,25|10,30,10,15|-5,25,8,13|-10,10,5,10
		Loop, Parse, DeathStar, |
			{
			Loop, Parse, A_Loopfield, `,
				{
				If (a_index = 1 or a_index = 3)
					X%a_index% := a_loopfield+%target%_posx
				If (a_index = 2 or a_index = 4)
					X%a_index% := a_loopfield+%target%_posy
				}
			Gdip_DrawLine(G, pPHotPink, x1,x2,x3,x4)
			}
		FileRead, AllUnits, AllUnitList.txt
		StringReplace, AllUnits, AllUnits, %target%|,,All
		FileDelete, AllUnitList.txt
		FileAppend, %AllUnits%, AllUnitList.txt
		%deadplayer%unitcount -= 1
		classfind := Position+2
		StringMid, deadplayerclass, target, classfind, 1
		%deadplayer%class%deadplayerclass%unitcount -= 1
		%target%_posx =
		%target%_posy =
		%target%_cooldown =
		%target%_attack =
		%target%_move =
		%target%_gather =
		%target%_scan =
		%target%_build =
		%target%_hp =
		%target%_visible =
		%target%_class =
		%target%_type =
		%attackingplayer%kills += 1
		%attackingplayer%totalkills += 1
		}
	return
	}
Else
	return 2 ;If target is out of range return 2
}

AA_CheckOccupancy(potentialx, potentialy) ; (281, 281)
{
GLOBAL
if potentialx not between 0 and 500
	return 1
if potentialy not between 0 and 500
	return 1
FileRead, AllUnits, AllUnitList.txt
StringSplit, unit, AllUnits, |
refreshloop := unit0-1
Loop %refreshloop%
	{
	checkunit := unit%a_index%
	; if absolute value of potential X position AND Y position
	; is the same as any unit's X,Y return true.
	xcheckdistance := abs(%checkunit%_posx - potentialx)
	ycheckdistance := abs(%checkunit%_posy - potentialy)
	IF (xcheckdistance < 20) AND (ycheckdistance < 20)
		return 1
	xcheckdistance := %checkunit%_posx - potentialx
	ycheckdistance := %checkunit%_posy - potentialy
	}
return 0
}

AA_DrawUnit(unit)
{
GLOBAL
StringGetPos, Position, unit, _
StringLeft, drawplayer, unit, Position
If (%drawplayer% = 1)
	playerbrush = pBORANGE
If (%drawplayer% = 2)
	playerbrush = pBPURPLE
widthheight := %unit%_hp*5
If widthheight = 20
	widthheight -= 1
Gdip_SetSmoothingMode(G, 0)
Gdip_FillRectangle(G,%playerbrush%,%unit%_posx,%unit%_posy,widthheight,widthheight)
Gdip_FillRectangle(G,%playerbrush%55,%unit%_posx,%unit%_posy,19,19)
unitvis := %unit%_visible
visx := %unit%_posx+12
visy := %unit%_posy+2
if (unitvis = 0)
	Gdip_FillRectangle(G,PbBLACK,visx,visy,4,4)
scansize := %unit%_scan
If (scansize > 0)
	{
	scanx := %unit%_posx+4
	scany := %unit%_posy+5
	Gdip_SetSmoothingMode(G, 4)
	fillarea := %unit%_scan*90
	Gdip_FillPie(G, pBLblue, scanx, scany, 12, 12, 0, fillarea)
	}
buildsize := %unit%_build
If (buildsize > 0)
	{
	buildline1x := %unit%_posx+1
	buildline1y := %unit%_posy+16
	buildline2x := %unit%_posx+18
	buildline2y := %unit%_posy+16
	buildline3x := %unit%_posx+5
	buildline3y := %unit%_posy+15
	buildline4x := %unit%_posx+5
	buildline4y := %unit%_posy+18
	buildline5x := %unit%_posx+13
	buildline5y := %unit%_posy+15
	buildline6x := %unit%_posx+13
	buildline6y := %unit%_posy+18
	Gdip_DrawLine(G, pPDarkGreyTHICK, buildline1x, buildline1y, buildline2x, buildline2y)
	Gdip_DrawLine(G, pPYellow3, buildline3x, buildline3y, buildline4x, buildline4y)
	If (buildsize = 2)
		Gdip_DrawLine(G, pPYellow3, buildline5x, buildline5y, buildline6x, buildline6y)
	}
moverate := %unit%_move
If (moverate > 0)
	{
	movelinex1 := %unit%_posx+10
	moveliney1 := %unit%_posy+9
	movelinex2 := %unit%_posx+10
	moveliney2 := %unit%_posy+19
	Gdip_SetSmoothingMode(G, 0)
	Gdip_DrawLine(G, pPGREY, movelinex1, moveliney1, movelinex2, moveliney2)
	}
gatherrate := %unit%_gather
If (gatherrate > 0)
	{
	If widthheight = 19
		widthheight -= 1
	Gdip_DrawRectangle(G, pPLGREEN, %unit%_posx, %unit%_posy, widthheight, widthheight)
	}
attacksize := %unit%_attack*5
If (attacksize > 0)
	{
	If (attacksize < 20)
		attackbrush = pBYELLOW
	If (attacksize = 20)
		attackbrush = pBYELLOWORANGE
	Attackpoly1x := %unit%_posx+10
	Attackpoly1y := %unit%_posy
	Attackpoly2x := %unit%_posx+5
	Attackpoly2y := %unit%_posy+attacksize
	Attackpoly3x := %unit%_posx+15
	Attackpoly3y := %unit%_posy+attacksize
	Points := attackpoly1x . "," . attackpoly1y . "|" . attackpoly2x . "," . attackpoly2y . "|" . attackpoly3x . "," . attackpoly3y
	Gdip_SetSmoothingMode(G, 4)
	Gdip_FillPolygon(G, %attackbrush%, Points)
	}
BitBlt(hdc_WINDOW,0, 0, 502,502, hdc_main,0,0) ;position of the GDI Image in the GUI
}

AA_endturn()
{
GLOBAL
FileRead, AllUnits, AllUnitList.txt
StringSplit, unit, AllUnits, |
cdloop := unit0-1
Loop %cdloop%
	{
	cdunit := unit%a_index%
	If (%cdunit%_cooldown = 0)
		continue
	%cdunit%_cooldown -= 1
	}
Guicontrol, Text, p1text, % "Units = " . %player1%unitcount . "`nKills = " . %player1%kills . "`nResources = " . %player1%resources . "`nGames won = " . %player1%gamewins . "`nWin Percent = " . %player1%winpercent . "%`nTotal Units = " . %player1%totalunitcount . "`nTotal Kills = " . %player1%totalkills . "`nTotal Resources = " . %player1%totalresources
Guicontrol, Text, p2text, % "Units = " . %player2%unitcount . "`nKills = " . %player2%kills . "`nResources = " . %player2%resources . "`nGames won = " . %player2%gamewins . "`nWin Percent = " . %player2%winpercent . "%`nTotal Units = " . %player2%totalunitcount . "`nTotal Kills = " . %player2%totalkills . "`nTotal Resources = " . %player2%totalresources
IF (mineralcurrent < 10)
	{
	random, spawncheck, 1, 3
	If (spawncheck = 3)
		AA_SpawnMineral() ; spawn new mineral
	}
If !%player1%_1_1_hp or !%player2%_1_2_hp
	{
	play = 0
	finalturncount += turncount
	turnaverage := finalturncount/gamenumber
	if !%player1%_1_1_hp
		winner := player2
	Else
		winner := player1
	CustomColor = EEAA99
	Gui, 2:+LastFound -Caption +ToolWindow +AlwaysOnTop
	Gui, 2:Color, %CustomColor%
	Gui, 2:Font, s32
	Gui, 2:Add, Text, cLime, %winner% wins!
	WinSet, TransColor, %CustomColor% 150
	Gui, 2:Show, NoActive
	%winner%gamewins += 1
	%player2%winpercent := (%player2%gamewins/gamenumber)*100
	%player1%winpercent := (%player1%gamewins/gamenumber)*100
	Guicontrol, Text, p1text, % "Units = " . %player1%unitcount . "`nKills = " . %player1%kills . "`nResources = " . %player1%resources . "`nGames won = " . %player1%gamewins . "`nWin Percent = " . %player1%winpercent . "%`nTotal Units = " . %player1%totalunitcount . "`nTotal Kills = " . %player1%totalkills . "`nTotal Resources = " . %player1%totalresources
	Guicontrol, Text, p2text, % "Units = " . %player2%unitcount . "`nKills = " . %player2%kills . "`nResources = " . %player2%resources . "`nGames won = " . %player2%gamewins . "`nWin Percent = " . %player2%winpercent . "%`nTotal Units = " . %player2%totalunitcount . "`nTotal Kills = " . %player2%totalkills . "`nTotal Resources = " . %player2%totalresources
	If (gamenumber = gamecount)
		pause
	return
	}
If (turncount > 2000)
	{
	stalematecheck1new := %player1%resources
	stalematecheck2new := %player2%resources
	If (stalematecheck1new = stalematecheck1old and stalematecheck2new = stalematecheck2old)
		stalemate += 1
	If (stalemate = 20)
		{
		play = 0
		CustomColor = EEAA99
		Gui, 2:+LastFound -Caption +ToolWindow +AlwaysOnTop
		Gui, 2:Color, %CustomColor%
		Gui, 2:Font, s32
		Gui, 2:Add, Text, cLime, STALEMATE
		WinSet, TransColor, %CustomColor% 150
		Gui, 2:Show, NoActive
		If (gamenumber = gamecount)
			pause
		return
		}
	stalematecheck1old := stalematecheck1new
	stalematecheck2old := stalematecheck2new
	}
Gui, Submit, NoHide
return
}

AA_SpawnMineral()
{
GLOBAL
Loop 15 ;this recycles the same 15 mineral numbers. selects a number 1-15 with a 0 value
	{
	If mineral%a_index%value = 0
		{
		mineralcount := a_index
		break
		}
	}
mineralcurrent += 1
Random, randomx, 1, 24
Random, randomy, 1, 24
Random, minval, 1, 4
randomx *= 20
randomy *= 20
adjust := 9-(minval*2)
randomx += adjust
randomy += adjust
mineral%mineralcount%x := randomx
mineral%mineralcount%y := randomy
mineral%mineralcount%value := minval
mineral%mineralcount%visible := 0
size := minval*4
Gdip_FillEllipse(G,pBGREY55, randomx, randomy, size, size)
;mvisx := mineral%a_index%x
;mvisy := mineral%a_index%y
;Gdip_FillRectangle(G,PbBLACK,mvisx,mvisy,19,19)
BitBlt(hdc_WINDOW,0, 0, 502,502, hdc_main,0,0) ;position of the GDI Image in the GUI
RETURN
}

AA_Gather(unit)
{
global
If (%unit%_gather = 0) ;check if scanning unit has gather function module
	return 0
If (%unit%_cooldown > 0) ;check cooldown
	return 3
Loop 15
	{
	If mineral%a_index%value >= 1 ;if a mineral has value > 1
		{
		target = mineral%a_index%
		xgatherdistance := abs(%target%x - %unit%_posx)
		ygatherdistance := abs(%Target%y - %unit%_posy)
		;msgbox %target% targeted. distancex = %xgatherdistance%. Distancey = %ygatherdistance%
		If (xgatherdistance <= 20) AND (ygatherdistance <= 20) ;if gathering unit is within range, gather
			{
			If (%target%visible = 0) ;check if target has been scanned yet
				return 4
			;msgbox, mineral within range. commencing gather.
			%target%value -= 1
			If (%target%value = 0)
				mineralcurrent -= 1
			gather := %unit%_gather
			StringGetPos, Position, unit, _
			StringLeft, player, unit, Position
			%player%resources += %gather%
			%player%totalresources += %gather%
			gatheranimationx1 := %unit%_posx+10
			gatheranimationy1 := %unit%_posy+10
			gatheranimationx2 := %target%x+10
			gatheranimationy2 := %target%y+10
			gathercirclex := %target%x+7
			gathercircley := %target%y+7
			height := gather*4
			Gdip_DrawLine(G, pPBLACK, gatheranimationx1,gatheranimationy1,gatheranimationx2,gatheranimationy2)
			Gdip_FillEllipse(G,pBBLACK, gathercirclex, gathercircley, height, height)
			%unit%_cooldown += 1
			BitBlt(hdc_WINDOW,0, 0, 502,502, hdc_main,0,0) ;position of the GDI Image in the GUI
			return 1
			}
		}
	}
return 2 ;if no minerals available, return 2
}

Player1Script(){
GLOBAL
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
MyPlayer:=Player1
MyEnemy:=Player2
2refreshloop := bunit0-1
Loop %2refreshloop%
	{
	2currentunit := bunit%a_index%
	If !2currentunit
		continue
	StringGetPos, Position, 2currentunit, _
	StringLeft, player, 2currentunit, Position
	If (player = %MyEnemy%)
		Continue
	2currentclass := %2currentunit%_class
	Gosub, %MyPlayer%Class%2currentclass%
	}
return
}

Player2Script(){
GLOBAL
FileRead, 1Units, AllUnitList.txt
StringSplit, aunit, 1Units, |
MyPlayer:=Player2
MyEnemy:=Player1
1refreshloop := aunit0-1
Loop %1refreshloop%
	{
        ;MyPlayer:
	1currentunit := aunit%a_index%
	If !1currentunit
		continue
	StringGetPos, Position, 1currentunit, _
	StringLeft, player, 1currentunit, Position
	If (player = %MyEnemy%)
		Continue
	1currentclass := %1currentunit%_class
	Gosub, %MyPlayer%Class%1currentclass%
	}
return
}
LagosClass1:
If (LagosResources > 3)
	{
	If (LagosClass2unitCount > 3)
		AA_Build(101101, 2currentunit, 3) ;if more than 5 workers, build an attacker
	Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
		AA_Build(102010, 2currentunit, 2) ; otherwise, build a worker
	}
return

LagosClass2:
If AA_Gather(2currentunit) = 2
	{
	;msgbox, no minerals in range, determining nearest mineral
	2distanceold = 999
	Loop 15
		{
		If (mineral%a_index%value > 0) ;if a mineral has value > 0
			{
			2target = mineral%a_index%
			2xgatherdistance := abs(%2target%x - %2currentunit%_posx)
			2ygatherdistance := abs(%2Target%y - %2currentunit%_posy)
			2distancenew := 2xgatherdistance+2ygatherdistance
			;msgbox, total distance to mineral = %1distancenew%
			If (2distancenew < 2distanceold)
				{
				2distanceold := 2distancenew
				2nearestmineral := 2target
				;msgbox, new nearest mineral found! %1target%
				}
			}
		}
	;msgbox, begin move towards %1NEARESTMINERAL%
	2xgatherdistance := %2nearestmineral%x - %2currentunit%_posx
	2ygatherdistance := %2nearestmineral%y - %2currentunit%_posy
	;msgbox, 1xgatherdistance = %1xgatherdistance% and 1ygatherdistance = %1ygatherdistance%
	If (2xgatherdistance = 0)
		2xvalue =
	If (2xgatherdistance < 0)
		2xvalue = L
	If (2xgatherdistance > 0)
		2xvalue = R
	If (2ygatherdistance = 0)
		2yvalue =
	If (2ygatherdistance > 0)
		2yvalue = D
	If (2ygatherdistance < 0)
		2yvalue = U
	2Dir := 2xvalue . 2yvalue
	;msgbox, direction to travel determined to be %1dir%
	If AA_Move(2currentunit, 2Dir) = 5
			AA_Move(2currentunit, "R")
	return
	}
If AA_Gather(2currentunit) = 4
	AA_Scan(2currentunit)
return


LagosClass3:
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
refreshloop3 := bunit0-1
2distanceold = 999
Loop %refreshloop3%
	{
	2checkunit := bunit%a_index%
	StringGetPos, Position, 2checkunit, _
	StringLeft, player, 2checkunit, Position
	If (player = "Lagos")
		Continue
	2xdistance := abs(%2checkunit%_posx - %2currentunit%_posx)
	2ydistance := abs(%2checkunit%_posy - %2currentunit%_posy)
	2distancenew := 2xdistance+2ydistance
	;msgbox, total distance to %checkunit% = %1distancenew%
	If (2distancenew < 2distanceold)
		{
		2distanceold := 2distancenew
		2nearestenemy := 2checkunit
		;msgbox, new nearest enemy found! %checkunit%
		}
	}
If AA_Attack(2currentunit, 2nearestenemy) = 2
	{
	;msgbox, attack out of range. begin move towards %2NEARESTENEMY%
	2xdistance := %2nearestenemy%_posx - %2currentunit%_posx
	2ydistance := %2nearestenemy%_posy - %2currentunit%_posy
;	msgbox, 1xdistance = %1xdistance% and 1ydistance = %1ydistance%
	If (2xdistance = 0)
		2xvalue =
	If (2xdistance < 0)
		2xvalue = L
	If (2xdistance > 0)
		2xvalue = R
	If (2ydistance = 0)
		2yvalue =
	If (2ydistance > 0)
		2yvalue = D
	If (2ydistance < 0)
		2yvalue = U
	2Dir := 2xvalue . 2yvalue
	;msgbox, direction to travel determined to be %2dir%
	If AA_Move(2currentunit, 2Dir) = 5
		AA_Move(2currentunit, "R")
	Return
	}
If AA_Attack(2currentunit, 2nearestenemy) = 4
	AA_Scan(2currentunit)
return

MorphaClass1:
If (morphaResources > 3)
	{
	If (morphaClass2unitCount > 3)
		AA_Build(101101, 1currentunit, 3) ;if more than 5 workers, build an attacker
	Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
		AA_Build(102010, 1currentunit, 2) ; otherwise, build a worker
	}
return

MorphaClass2:
;msgbox, gather subroutine initiated for unit %1currentunit%
If AA_Gather(1currentunit) = 2
	{
	;msgbox, no minerals in range, determining nearest mineral
	1distanceold = 999
	Loop 15
		{
		If (mineral%a_index%value > 0) ;if a mineral has value > 0
			{
			1target = mineral%a_index%
			1xgatherdistance := abs(%1target%x - %1currentunit%_posx)
			1ygatherdistance := abs(%1Target%y - %1currentunit%_posy)
			1distancenew := 1xgatherdistance+1ygatherdistance
			;msgbox, total distance to mineral = %1distancenew%
			If (1distancenew < 1distanceold)
				{
				1distanceold := 1distancenew
				1nearestmineral := 1target
				;msgbox, new nearest mineral found! %1target%
				}
			}
		}
	;msgbox, begin move towards %1NEARESTMINERAL%
	1xgatherdistance := %1nearestmineral%x - %1currentunit%_posx
	1ygatherdistance := %1nearestmineral%y - %1currentunit%_posy
	;msgbox, 1xgatherdistance = %1xgatherdistance% and 1ygatherdistance = %1ygatherdistance%
	If (1xgatherdistance = 0)
		1xvalue =
	If (1xgatherdistance < 0)
		1xvalue = L
	If (1xgatherdistance > 0)
		1xvalue = R
	If (1ygatherdistance = 0)
		1yvalue =
	If (1ygatherdistance > 0)
		1yvalue = D
	If (1ygatherdistance < 0)
		1yvalue = U
	1Dir := 1xvalue . 1yvalue
	;msgbox, direction to travel determined to be %1dir%
	If AA_Move(1currentunit, 1Dir) = 5
		AA_Move(1currentunit, "R")
	return
	}
If AA_Gather(1currentunit) = 4
	AA_Scan(1currentunit)
return

MorphaClass3:
;msgbox, %1currentunit% class 3 initiated
FileRead, 1Units, AllUnitList.txt
StringSplit, aunit, 1Units, |
refreshloop2 := aunit0-1
1distanceold = 999
Loop %refreshloop2%
	{
	1checkunit := aunit%a_index%
	StringGetPos, Position, 1checkunit, _
	StringLeft, player, 1checkunit, Position
	;msgbox checking unit %1checkunit%. unti belongs to %player%
	If (player = "morpha")
		Continue
	;msgbox, player belongs to lagos, the enemy. continuing attack.
	1xdistance := abs(%1checkunit%_posx - %1currentunit%_posx)
	1ydistance := abs(%1checkunit%_posy - %1currentunit%_posy)
	1distancenew := 1xdistance+1ydistance
	If (1distancenew < 1distanceold)
		{
		1distanceold := 1distancenew
		1nearestenemy := 1checkunit
		;msgbox, new nearest enemy found! %checkunit%
		}
	}
If AA_Attack(1currentunit, 1nearestenemy) = 2
	{
	;msgbox, begin move towards %1NEARESTENEMY%
	1xdistance := %1nearestenemy%_posx - %1currentunit%_posx
	1ydistance := %1nearestenemy%_posy - %1currentunit%_posy
	;msgbox, 1xdistance = %1xdistance% and 1ydistance = %1ydistance%
	If (1xdistance = 0)
		1xvalue =
	If (1xdistance < 0)
		1xvalue = L
	If (1xdistance > 0)
		1xvalue = R
	If (1ydistance = 0)
		1yvalue =
	If (1ydistance > 0)
		1yvalue = D
	If (1ydistance < 0)
		1yvalue = U
	1Dir := 1xvalue . 1yvalue
	;msgbox, direction to travel determined to be %1dir%
	If AA_Move(1currentunit, 1Dir) = 5
		AA_Move(1currentunit, "R")
	return
	}
If AA_Attack(1currentunit, 1nearestenemy) = 4
	{
	;msgbox, enemy not scanned. scanning now.
	AA_Scan(1currentunit)
	}
return