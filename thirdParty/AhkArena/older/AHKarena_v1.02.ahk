

; version 1.02
#NoEnv
#SINGLEINSTANCE force

If (!pToken := Gdip_Startup()){
  MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system!
  ExitApp
}
SetFormat, float, 0.0

InputBox, player1, Player 1's Name?,,, 190, 200
InputBox, player2, Player 2's Name?,,, 190, 200
InputBox, gamecount, Number of games?,,, 190, 200
%player1% := 1
%player2% := 2
%player1%enemy := player2
%player2%enemy := player1
%player1%gamewins = 0
%player2%gamewins = 0
Gui, Add, Text, x516 y147 w110 h20 cFF9900, %player1% - Player 1
Gui, Add, Text, x516 y287 w110 h20 c663399, %player2% - Player 2
Gui, Add, Text, x516 y167 w110 h120 vp1text, % "Units = " . %player1%unitcount . "`nKills = " . %player1%kills . "`nResources = " . %player1%resources . "`nGames won = " . %player1%gamewins . "`nWin Percent = " . %player1%winpercent . "%`nTotal Units = " . %player1%totalunitcount . "`nTotal Kills = " . %player1%totalkills . "`nTotal Resources = " . %player1%totalresources
Gui, Add, Text, x516 y307 w110 h120 vp2text, % "Units = " . %player2%unitcount . "`nKills = " . %player2%kills . "`nResources = " . %player2%resources . "`nGames won = " . %player2%gamewins . "`nWin Percent = " . %player2%winpercent . "%`nTotal Units = " . %player1%totalunitcount . "`nTotal Kills = " . %player1%totalkills . "`nTotal Resources = " . %player1%totalresources
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
   pPYELLOWORANGE		:= Gdip_CreatePen(0xff666666, 2)
   pPBLACK				:= Gdip_CreatePen(0xff000000, 1)
   pPRed				:= Gdip_CreatePen(0xffFF0000, 1)
   pPYellow				:= Gdip_CreatePen(0xffFFFF00, 2)
   pBLblue				:= Gdip_BrushCreateSolid(0xff3333FF)
; Now we draw on our Frame:
Gdip_FillRectangle(G,pBWHITE,0,0,500,500)    ;white background
; ++++++  GDI Stuff ends here +++++++++

gosub, setup ;new game setup subroutine
return


buttonstart:
Gui, Submit, NoHide
Loop %gamecount%
	{
	Loop
		{
		Sleep %SpeedSlider%
		turncount := a_index
		Guicontrol, Text, maintext, MainText`nGame = %gamenumber%`nTurn = %a_index%`nAvg. # Turns: %turnaverage%
		player1script() ; execute player 1's script
		Sleep %SpeedSlider%
		AA_Refresh() ; deletes animations, redraws board and all units.
		player2script() ; execute player 2's script
		Sleep %SpeedSlider%
		AA_Refresh() ; deletes animations, redraws board and all units.
		AA_endturn() ; change cooldowns, spawn new mineral, check for winner
		If (play = 0)
			{
			gosub, setup ;if game ends, start a new game.
			break
			}
		}
	}
return

setup:
FileDelete, allunitlist.txt
play = 1
gamenumber += 1
unitID = 0
%player1%kills = 0
%player2%kills = 0
%player1%unitcount = 0
%player2%unitcount = 0
%player1%resources = 0
%player2%resources = 0
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
Pause

GuiClose:
ExitApp


