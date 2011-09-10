#SingleInstance, off	;allow multiple instances

	target := "Script2"
	stress := 1000,   x:=300
	;========================

	Gui, +LastFound	  +AlwaysOnTop
	hScript := WinExist() + 0

	Gui, Font, s10
	Gui, Add, Edit,		 vMyMsg  w200 , Message to %target%
	Gui, Add, Edit,  x+0 vMyPort w50, 100

	Gui, Font, s8
	Gui, Add, Button, x+5	gOnSend		  , Send
	Gui, Add, Button, x+5	gOnSendBinary , Send Binary
	Gui, Add, Button, x+5	gOnStress	  , Stress

	Gui, Add, ListBox,xm w440 h300 vMyLB,

	Gui, Show, x%x%	AutoSize
	GuiControl, , MyLB, This script HWND: %hScript%
	IPC_SetHandler("OnData")
return

OnData(Hwnd, Data, Port, Size) {
	global myLB

	if Size =
		 s = %Port%      Hwnd: %HWND%      Message: %Data%
	else {		  
		  x := NumGet(Data+0), y := NumGet(Data+4)
		  s = %Port%     Hwnd: %HWND%      Binary Data: POINT (%x%, %y%)      DataSize: %Size%
	}	
	GuiControl, , MyLB, %s%
}


OnSend:
	Gui, Submit, NoHide
	if !IPC_Send( WinExist( target ), MyMsg, MyPort)
		MsgBox Sending failed
return

OnStress:
	Gui, Submit, NoHide
	if !(h := WinExist( target ))
		MsgBox Host doesn't exist
	loop, %stress%
	   IPC_Send(h, MyMsg " : " A_Index, MyPort)
return

OnSendBinary:
	Gui, Submit, NoHide
	VarSetCapacity(POINT, 8), NumPut(2000, POINT), NumPut(8000, POINT, 4)
	if !IPC_Send( WinExist( target ), &POINT, MyPort, 8)
		MsgBox Sending failed
return

GuiClose:
	ExitApp
return

#include ..\IPC.ahk