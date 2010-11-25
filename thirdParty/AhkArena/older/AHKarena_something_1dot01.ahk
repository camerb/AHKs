#include lib\gdip.ahk
#include lib\aa.ahk
#include lib\player1script.ahk
#include lib\player2script.ahk

; version 1.01
#NoEnv
#SINGLEINSTANCE force

If (!pToken := Gdip_Startup()){
  MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system!
  ExitApp
}
SetFormat, float, 0.0
player1gamewins = 0
player2gamewins = 0
Gui, Add, GroupBox, x506 y7 w110 h490 , AHK Arena
Gui, Add, Text, x512 y200 w100 h100 vp1text, % "Player 1`n" . player1 . "`nUnits = " . player1unitcount . "`nKills = " . player1kills . "`nResources = " . player1resources . "`nGames won = " . player1gamewins . "`nWin Percent = " . player1winpercent . "%"
Gui, Add, Text, x512 y320 w100 h100 vp2text, % "Player 2`n" . player2 . "`nUnits = " . player2unitcount . "`nKills = " . player2kills . "`nResources = " . player2resources . "`nGames won = " . player2gamewins . "`nWin Percent = " . player2winpercent . "%"
Gui, Add, Text, x522 y30 w90 h50 vmaintext, MainText
Gui, Add, Text, x522 y90 w90 h40 vprogress, Progress
Gui, Add, Text, x516 y440 w90 h40, Game Speed
Gui, Add, Slider, x510 y460 w100 h40 vSpeedSlider Range1-400 tooltip invert, 200
Gui, Add, Button, x512 y140 w90 h30, Start
; Generated using SmartGUI Creator 4.0
Gui, Show, x124 y78 h505 w625, AHK Arena


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
   pPBLACK				:= Gdip_CreatePen(0xff000000, 1)
   pPRed				:= Gdip_CreatePen(0xffFF0000, 1)
   pPYellow				:= Gdip_CreatePen(0xffFFFF00, 2)
   pBLblue				:= Gdip_BrushCreateSolid(0xff3333FF)
; Now we draw on our Frame:
Gdip_FillRectangle(G,pBWHITE,0,0,500,500)    ;white background
; ++++++  GDI Stuff ends here +++++++++

gosub, setup ;new game setup subroutine
InputBox, player1, Player 1's Name?,,, 190, 200
InputBox, player2, Player 2's Name?,,, 190, 200
InputBox, gamecount, Number of games?,,, 190, 200
%player1% := 1
%player2% := 2
%player1%enemy := 2
%player2%enemy := 1
return


buttonstart:
Gui, Submit, NoHide
Loop %gamecount%
	{
	Loop
		{
		Sleep %SpeedSlider%
		Guicontrol, Text, maintext, MainText`nGame = %gamenumber%`nTurn = %a_index% ; update the GUI with current turn  and game #
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
Loop 9
	{
	Player1Class%a_index%unitcount = 0
	Player2Class%a_index%unitcount = 0
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
AA_Spawn(1, 1)
AA_Spawn(2, 1)
Player1Resources = 6
Player2Resources = 6
return


GuiClose:
ExitApp