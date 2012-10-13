/*
Title: AHK Messenger
Author: adabo, RaptorX
*/
#include %A_ScriptDir%\lib\ws.ahk
#Persistent
NickName := A_UserName
OnExit, ExitRoutine

; GUI
	Gui, Client:+Resize
	Gui, Client: Add, Edit, w200 h200 vLog +ReadOnly HwndLogID
	Gui, Client: Add, Edit, w200 -WantReturn vGuiMessage -0x100 HwndMsgID
	Gui, Client: Add, Button, Default gSendMessage HwndSendID, Send
	Gui, Client: Show

; Initialize
	WS_LOGTOCONSOLE := 1
	WS_Startup()

; Port/Socket setup
	client := WS_Socket("TCP", "IPv4")
	WS_Connect(client, "99.23.4.199", "12345")
	WS_HandleEvents(client, "READ")
return

SendMessage:
	Gui, Client:Submit, NoHide
	if (!GuiMessage)
		return
	WS_Send(client, NickName . ": " . GuiMessage)
	GuiControl, Client:, GuiMessage
	autoScroll()
return

WS_OnRead(socket){
	Global
	WS_Recv(socket, ServerMessage)
	Gui, Client:Submit, NoHide
	GuiControl, Client:, Log, % Log . "`n" . ServerMessage
	autoScroll()
}

autoScroll(){
	Global
	SendMessage, 0x00BA, 0, 0,, AHK_ID %LogID%  ; EM_GETLINECOUNT
	LNCount := ErrorLevel - 1
	SendMessage, 0x00BB, LNCount,,, AHK_ID %LogID%  ; EM_LINEINDEX (Gets index number of line)
	CaretTo := ErrorLevel
	SendMessage, 0xB1, CaretTo, CaretTo,, AHK_ID %LogID%
	SendMessage, 0x00B7, 0, 0,, AHK_ID %LogID%  ; EM_SCROLLCARET
}

ClientGuiSize:
    GuiControl, MoveDraw, %LogID%, % "w"A_GuiWidth - 20 "h"A_GuiHeight - 80
    GuiControl, MoveDraw, %MsgID%, % "y"A_GuiHeight - 60 "w"A_GuiWidth - 20
    GuiControl, MoveDraw, %SendID%, % "y"A_GuiHeight - 24
return

ClientGuiClose:
ExitRoutine:
	WS_CloseSocket(client)
	WS_Shutdown()
ExitApp