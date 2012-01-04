#include FcnLib.ahk

GameStarted := 0
PlayerCurrent := 1
ButtonsPressed := 0

Gui, Font, S22 CDefault, Verdana
Gui, Add, Button, x22 y30 w60 h60 vA1 gButtonPress, A
Gui, Add, Button, x82 y30 w60 h60 vA2 gButtonPress
Gui, Add, Button, x142 y30 w60 h60 vA3 gButtonPress
Gui, Add, Button, x22 y90 w60 h60 vB1 gButtonPress
Gui, Add, Button, x82 y90 w60 h60 vB2 gButtonPress
Gui, Add, Button, x142 y90 w60 h60 vB3 gButtonPress
Gui, Add, Button, x22 y150 w60 h60 vC1 gButtonPress
Gui, Add, Button, x82 y150 w60 h60 vC2 gButtonPress
Gui, Add, Button, x142 y150 w60 h60 vC3 gButtonPress
Gui, Font, S9 CDefault, Verdana
Gui, Add, GroupBox, x12 y10 w200 h210 vStatus, No Game Started
Menu, FileMenu, Add, New Game, NewGame
Menu, FileMenu, Add
Menu, FileMenu, Add, Statistics
Menu, FileMenu, Add, Options
Menu, FileMenu, Add
Menu, FileMenu, Add, Exit, GuiClose
Menu, MenuBar, Add, File, :FileMenu

Menu, HelpMenu, Add, About
Menu, MenuBar, Add, Help, :HelpMenu

Gui, Menu, MenuBar
Gui, Show, x539 y395 h237 w232, TicTacToe
Return

ButtonPress:
If (GameStarted = 1)
{
	GuiControlGet, %A_GuiControl%
	If (%A_GuiControl% = "")
	{
		GuiControlGet, Status
		If (PlayerCurrent = 1)
		{
			GuiControl,, %A_GuiControl%, X
			PlayerCurrent := 2
			GuiControl,, Status, % SubStr(Status,1,-1) . PlayerCurrent
		}
		Else
		{
			GuiControl,, %A_GuiControl%, O
			PlayerCurrent := 1
			GuiControl,, Status, % SubStr(Status,1,-1) . PlayerCurrent
		}
		ButtonsPressed += 1
		If (ButtonsPressed = 9)
		{
			GameStarted = 0
			GuiControl,, Status, Game Ended, Draw!
		}
	}
}
Return

NewGame:
If (GameStarted = 1)
   GuiControl,, Status, Game Restarted! - P1
Else
   GuiControl,, Status, Game Started! - P1
GameStarted := 1
ButtonsPressed := 0
PlayerCurrent := 1
GuiControl,, A1
GuiControl,, A2
GuiControl,, A3
GuiControl,, B1
GuiControl,, B2
GuiControl,, B3
GuiControl,, C1
GuiControl,, C2
GuiControl,, C3
Return

Statistics:
; Put GuiCode and IniReading code here
Return

Options:
; Gui Code, InIReading/Writing code here
Return

About:
; Put Gui Code Here
Return

GuiClose:
ExitApp

 ~esc::ExitApp