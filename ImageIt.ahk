;#include FcnLib.ahk
#include thirdParty/Gdip.ahk
#include thirdParty/HTTPRequest.ahk

;Image It by kooster
; quick screenshot upload
; uploads screenshots to imgur by doing a PRINTSCREEN + MouseDrag

#SingleInstance force
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%
gdip_startup()
Anonymous_API_Key := "6ebe2dbce1229b944719ff0125fe4e81"
Temp_Image := A_Temp "\Temp_Image.jpg"
DragBoxColor := "6EB5C5"
Capture := 1
IfExist,Image It.ico
	Menu, Tray, Icon,Image It.ico
Menu, Tray, Click, 1
Menu, Tray, NoStandard
Menu, Tray, Add, Upload
Menu, Tray, Add, Open
Menu, Tray, Add, Copy
Menu, Tray, Add
Menu, Tray, Add, Settings
Menu, Tray, Add
Menu, Tray, Add, About
Menu, Tray, Add
Menu, Tray, Add, Exit
Menu, Tray, Add, Show_Menu
Menu, Tray, Default,Show_Menu
IfExist,%A_ScriptDir%\Settings.ini
{
	IniRead,Default,%A_ScriptDir%\Settings.ini,Settings,Default
	Menu, Tray, Check,%Default%
}
else
{
	TrayTip,,Thank you for choosing kookster's Screen clipper`.`nTo change the the Default press Prt_Scr`+ o`, u or c`, or just Click the system tray icon and set things accordingly`.,10
	Default := "Open"
	IniWrite,Upload,%A_ScriptDir%\Settings.ini,Settings,Default
	Menu, Tray, Check,Upload
}
Loop
{
	KeyWait,PrintScreen,Down
	SetSystemCursor("IDC_Cross")
	KeyWait,PrintScreen,Up
	RestoreCursors()
}
return

Show_Menu:
Menu, Tray, DeleteAll
Menu, Tray, Add, Upload
Menu, Tray, Add, Open
Menu, Tray, Add, Copy
Menu, Tray, Add
Menu, Tray, Add, Settings
Menu, Tray, Add
Menu, Tray, Add, About
Menu, Tray, Add
Menu, Tray, Add, Exit
IfExist,%A_ScriptDir%\Settings.ini
{
	IniRead,Default,%A_ScriptDir%\Settings.ini,Settings,Default
	Menu, Tray, Check,%Default%
}
else
{
	Default := "Upload"
	IniWrite,Upload,%A_ScriptDir%\Settings.ini,Settings,Default
	Menu, Tray, Check,Upload
}
Menu, Tray, Show
Return

Exit:
ExitApp

About:
Gui,Destroy
Capture := 0
Gui, 1:Add, Text, x12 y10 w460 h20 , Thank you for choosing Image It. Copyright 2011 Luke C. Fairchild. All rights reserved.
Gui, 1:Add, Text, x22 y540 w50 h20 , [VxE]
Gui, 1:Add, Text, x22 y560 w20 h20 , tic
Gui, 1:Add, Text, x22 y580 w40 h20 , serenity
Gui, 1:Add, Text, x22 y600 w40 h20 , sumon
Gui, 1:Add, Text, x22 y620 w40 h20 , tidbit
Gui, 1:Add, Text, x132 y540 w70 h20 , HTTPRequest
Gui, 1:Add, Text, x132 y560 w40 h20 , Gdip
Gui, 1:Add, Text, x132 y580 w90 h20 , SetSystemCursor
Gui, 1:Add, Text, x132 y600 w110 h20 , Inspiration from zizzorz
Gui, 1:Add, Text, x132 y620 w110 h20 , Image It icon
Gui, 1:Add, GroupBox, x12 y520 w240 h120 , Credits
Gui, 1:Add, Text, x22 y60 w460 h70 , In Image It there are three default settings: Copy`, Open and Upload. You can switch inbetween these settings by either clicking on the desired one in the system tray icon. The other way you can change the setting is by pushing Print Screen and the first letter of the option you want. For Example:
Gui, 1:Add, Text, x32 y120 w440 h20 , If I want to change the default to open I would press: Printscreen and O at the same time.
Gui, 1:Add, Text, x62 y190 w420 h30 , Any image taken by Image It will be copied into the clipboard. You can then go into any image editor or a program like office and paste it.
Gui, 1:Add, Text, x22 y190 w40 h30 , Copy:
Gui, 1:Add, Text, x22 y220 w40 h30 , Open:
Gui, 1:Add, Text, x22 y250 w40 h30 , Upload:
Gui, 1:Add, Text, x62 y220 w420 h30 , Any image taken by Image It will be opened into Paint or any program you choose. The default program can be changed from the system tray settings.
Gui, 1:Add, Text, x62 y250 w420 h50 , Any image taken by Image It will be Uploaded online to imgur. While it is uploading you can hit esc to cancel. When the upload is complete the link to the image will be copied to your cliboard for you to paste wherever you want.
Gui, 1:Add, Button, x372 y580 w100 h30 Default gClose_About, Ok
Gui, 1:Add, Text, x22 y330 w70 h20 , Print Screen:
Gui, 1:Add, Text, x22 y380 w120 h20 , Ctrl + Alt + Print Screen:
Gui, 1:Add, Text, x22 y430 w140 h20 , Print Screen + Mouse Drag:
Gui, 1:Add, GroupBox, x12 y40 w480 h110 , How to use
Gui, 1:Add, GroupBox, x12 y170 w480 h130 , Settings
Gui, 1:Add, GroupBox, x12 y310 w480 h200 , Functions
Gui, 1:Add, Text, x22 y350 w420 h20 , Takes a image of your entire desktop and all windows that are visible on it.
Gui, 1:Add, Text, x22 y400 w420 h20 , Takes a image of the currently active window.
Gui, 1:Add, Text, x22 y450 w460 h50 , Takes a image of an area that you select while holding print screen then click and drag the mouse. When you release the mouse button a preview of the area you selected will show up in the middle of your screen. Click the preview to approve the image.
Gui, 1:Show, w505 h645, About Image It
return

Close_About:
Gui,1:Destroy
Capture := 1
return

GuiClose:
Capture := 1
Return

Settings:
Capture := 0
MsgBox,Settings here
Capture := 1
return

~RButton::
Menu, Tray, DeleteAll
Menu, Tray, Add, Upload
Menu, Tray, Add, Open
Menu, Tray, Add, Copy
Menu, Tray, Add
Menu, Tray, Add, Settings
Menu, Tray, Add
Menu, Tray, Add, About
Menu, Tray, Add
Menu, Tray, Add, Exit
IfExist,%A_ScriptDir%\Settings.ini
{
	IniRead,Default,%A_ScriptDir%\Settings.ini,Settings,Default
	Menu, Tray, Check,%Default%
}
else
{
	Default := "Upload"
	IniWrite,Upload,%A_ScriptDir%\Settings.ini,Settings,Default
	Menu, Tray, Check,Upload
}
Return

~LButton::
MouseGetPos,,,Win
WinGetTitle, Title, ahk_id %Win%
If ( Capture = 1 )
	If ( Title = A_ScriptName )
	{
		If ( Default = "Copy" )
		{
			gdip_SetBitmapToClipboard(Image)
			Traytip,,Copy Successful!
		}
		If ( Default = "Upload" )
		{
			Gui,3:Destroy
			Gui, 2:Add, Progress, x5 y4 w284 h20 -Smooth vComplete,
			Gui, 2:-SysMenu +AlwaysOnTop
			Gui, 2:Show, w294 h29, Uploading
			gdip_SaveBitmapToFile( Image , Temp_Image, 100)
			If ( Clipboard := Imgur_Upload( Temp_Image , Anonymous_API_Key, xml ) )
			{
				GuiControl,2:, Complete, 100
				Gui, 2:Show, NA w294 h29, Upload Successful! Link copied to clipboard!
			}
			FileDelete, %Temp_Image%
			Sleep 2500
			Gui,2:Destroy
		}
		If ( Default = "Open" )
			Run, %A_WinDir%\system32\mspaint.exe %Temp_Image%
	}
Gui,3:Destroy
Menu, Tray, Add, Show_Menu
Menu, Tray, Default,Show_Menu
Return

~esc::
IfWinActive,ahk_PID %PID%
	If ( A_IsCompiled )
	{
		Run,%A_ScriptFullPath%
		ExitApp
	}
	Else
		Reload
Return

^!PrintScreen::
Hotkey,~LButton,Off
Gui,3:Destroy
KeyWait,PrintScreen,Up
RestoreCursors()
WinGet,ID,ID,A
Image := gdip_bitmapFromHWND(ID)
If ( Default = "Copy" )
	gdip_SetBitmapToClipboard(Image)
If ( Default = "Upload" )
	MsgBox,4,,Do you want to Upload your window shot?
IfMsgBox Yes
{
	Gui, 2:Add, Progress, x5 y4 w284 h20 -Smooth vComplete,
	Gui, 2:-SysMenu +AlwaysOnTop
	Gui, 2:Show, w294 h29, Uploading
	gdip_SaveBitmapToFile(Image, Temp_Image , 100)
	If ( Clipboard := Imgur_Upload( Temp_Image , Anonymous_API_Key, xml ) )
		Gui, 2:Show, NA w294 h29, Upload Successful! Link copied to clipboard!
	FileDelete, %Temp_Image%
	Sleep 2500
	Gui,2:Destroy
}
If ( Default = "Open" )
{
	gdip_SaveBitmapToFile(Image, Temp_Image , 100)
	Run, %A_WinDir%\system32\mspaint.exe %Temp_Image%
}
Hotkey,~LButton,On
return

PrintScreen & LButton::
Gui,3:Destroy
SetSystemCursor("IDC_Cross")
DragBox(MX, MY, MXend, MYend, MW, MH, DragBoxColor)
Image_Area = %MX%|%MY%|%MW%|%MH%
Sleep, 50
Image := gdip_BitmapFromScreen(Image_Area)
gdip_SaveBitmapToFile( Image , Temp_Image , 100)
Gui,3:Destroy
Gui, 3:Add, Picture ,x2 y2,%Temp_Image%.
gui, 3:-Caption +ToolWindow +AlwaysOnTop
MW:=MW+4, MH:=MH+4, MX:= MX-2, MY:= MY-2
Gui, 3:Color, 000000
Gui,3:Show, w%MW% h%MH%
Traytip,,Click the preview to %Default% the image.
Return

PrintScreen::
Hotkey,~LButton,Off
Gui,3:Destroy
KeyWait,PrintScreen,Up
RestoreCursors()
SysGet , MonitorCount, MonitorCount
Width := 0
Loop, %MonitorCount%
{
    SysGet, Monitor, Monitor, %A_Index%
    SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
	Width := ( MonitorWorkAreaRight - Monitorleft ) + Width
}
Image_Area = 0|0|%Width%|%A_ScreenHeight%
Image := gdip_BitmapFromScreen(Image_Area)
If ( Default = "Copy" )
{
	gdip_SetBitmapToClipboard(Image)
	Traytip,,Copy Successful!
}
If ( Default = "Upload" )
	MsgBox,4,,Do you want to Upload your screen shot?
IfMsgBox Yes
{
	Gui, 2:Add, Progress, x5 y4 w284 h20 -Smooth vComplete,
	Gui, 2:-SysMenu +AlwaysOnTop
	Gui, 2:Show, w294 h29, Uploading
	gdip_SaveBitmapToFile( Image , Temp_Image , 100)
	If ( Clipboard := Imgur_Upload( Temp_Image , Anonymous_API_Key, xml ) )
		Gui, 2:Show, w294 h29, Upload Successful! Link copied to clipboard!
	FileDelete, %Temp_Image%
	Sleep 2500
	Gui,2:Destroy
}
If ( Default = "Open" )
{
	gdip_SaveBitmapToFile(Image, Temp_Image , 100)
	Run, %A_WinDir%\system32\mspaint.exe %Temp_Image%
}
Hotkey,~LButton,On
Return

PrintScreen & u::
Upload:
Menu, Tray, Check,Upload
Menu, Tray, UnCheck,Open
Menu, Tray, UnCheck,Copy
TrayTip ,, Default set to Upload , 1
Default := "Upload"
IniWrite,%Default%,%A_ScriptDir%\Settings.ini,Settings,Default
return

PrintScreen & o::
Open:
Menu, Tray, Check,Open
Menu, Tray, UnCheck,Upload
Menu, Tray, UnCheck,Copy
TrayTip ,, Default set to Open , 1
Default := "Open"
IniWrite,%Default%,%A_ScriptDir%\Settings.ini,Settings,Default
return

PrintScreen & c::
Copy:
Menu, Tray, Check,Copy
Menu, Tray, UnCheck,Upload
Menu, Tray, UnCheck,Open
TrayTip ,, Default set to Copy , 1
Default := "Copy"
IniWrite,%Default%,%A_ScriptDir%\Settings.ini,Settings,Default
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                 Functions                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DragBox(ByRef OutX1, ByRef OutY1, ByRef OutX2, ByRef OutY2, Byref OutW="", ByRef OutH="", Color="0000FF") {
	CoordMode Mouse
	MouseGetPos oX, oY
	Gui, 5: +alwaysontop -Caption +Border +ToolWindow +LastFound
	Gui, 5:Color, %Color%
	If (Color = "0000FF")
		WinSet, TransColor, 0000FF
	else
		WinSet, Transparent, 80
	While GetKeyState("LButton", "P")
	{
		MouseGetPos cX, cY
		H := abs(oY-cY), W := abs(oX-cX)
			,GuiX := oX, GuiY := oY
		If ( cY < oY )
			GuiY := cY
		If ( cX < oX )
			GuiX := cX
		Gui, 5:Show, w%W% h%H% x%GuiX% y%GuiY%
	}
	Gui,5:Cancel
	OutX1 := oX < cX ? oX : cX
		,	OutY1 := oY < cY ? oY : cY
		,	OutX2 := oX > cX ? oX : cX
		,	OutY2 := oY > cY ? oY : cY
		,	OutW := OutX2 - OutX1
		,	OutH := OutY2 - OutY1
	return 0
}

RestoreCursors() {
   SPI_SETCURSORS := 0x57
   DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}

SetSystemCursor( Cursor = "", cx = 0, cy = 0 ) {
	BlankCursor := 0, SystemCursor := 0, FileCursor := 0
	SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
		,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
		,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
		,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
	If Cursor =
	{
		VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
		BlankCursor = 1
	}
	Else If SubStr( Cursor,1,4 ) = "IDC_"
	{
		Loop, Parse, SystemCursors, `,
		{
			CursorName := SubStr( A_Loopfield, 6, 15 )
			CursorID := SubStr( A_Loopfield, 1, 5 )
			SystemCursor = 1
			If ( CursorName = Cursor )
			{
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )
				Break
			}
		}
		If CursorHandle =
		{
			Msgbox,, SetCursor, Error: Invalid cursor name
			CursorHandle = Error
		}
	}
	Else If FileExist( Cursor )
	{
		SplitPath, Cursor,,, Ext
		If Ext = ico
			uType := 0x1
		Else If Ext in cur,ani
			uType := 0x2
		Else
		{
			Msgbox,, SetCursor, Error: Invalid file type
			CursorHandle = Error
		}
		FileCursor = 1
	}
	Else
	{
		Msgbox,, SetCursor, Error: Invalid file path or cursor name
		CursorHandle = Error
	}
	If CursorHandle != Error
	{
		Loop, Parse, SystemCursors, `,
		{
			If BlankCursor = 1
			{
				Type = BlankCursor
				%Type%%A_Index% := DllCall( "CreateCursor"
					, Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
			Else If SystemCursor = 1
			{
				Type = SystemCursor
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )
				%Type%%A_Index% := DllCall( "CopyImage"
					, Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
			Else If FileCursor = 1
			{
				Type = FileCursor
				%Type%%A_Index% := DllCall( "LoadImageA"
					, UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 )
				DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
		}
	}
}

Imgur_Upload( image_file, Anonymous_API_Key, byref output_XML="" ) { ; Function by [VxE].
   Static Imgur_Upload_Endpoint := "http://api.imgur.com/2/upload.xml"
   FileGetSize, size, % image_file
   FileRead, output_XML, % "*c " image_file
   If HTTPRequest( Imgur_Upload_Endpoint "?key=" Anonymous_API_Key, output_XML
      , Response_Headers := "Content-Type: application/octet-stream`nContent-Length: " size
      , "Callback: CustomProgress" )
   && ( pos := InStr( output_XML, "<original>" ) )
      Return SubStr( output_XML, pos + 10, Instr( output_XML, "</original>", 0, pos ) - pos - 10 )
   Else Return ""
}

CustomProgress( pct, total ) {
global
CoordMode, ToolTip, Screen
If ( pct = "" )
	Tooltip
Else If ( pct < 0 )
{
	Var = % "Uploading " Round( 100 * ( pct + 1 ), 1 ) "%. "
		. Round( ( pct + 1 ) * total, 0 ) " of " total " bytes."
	Width :=  A_ScreenWidth - ( StrLen(Var) * 5 )
	SysGet, VirtualHeight, 79
	Complete := Round( 100 * ( pct + 1 ), 1 )
	GuiControl,2:, Complete, %Complete%
	StringSplit,Percent,Complete,.
	Gui +LastFound
	Gui, 2:Show, NA , Uploading %Percent1%`%
	WinGet,PID,PID
}
Else If ( 0 <= pct )
	Gui, 2:Show, NA w294 h29, Waiting for Link.
}

XML_MakePretty( XML, Tab="`t" ) { ; Function by [VxE].
   oel := ErrorLevel, PrevCloseTag := 0, tabs := "", tablen := StrLen( tab )
   StringLen, pos, XML
   Loop, Parse, XML, <, % "`t`r`n "
      If ( A_Index = 1 )
         VarSetCapacity( XML, pos, 0 )
      Else
      {
         StringGetPos, pos, A_LoopField, >
         StringMid, b, A_LoopField, pos, 1
         StringLeft, a, A_LoopField, 1
         If !( OpenTag := a != "/" ) * ( CloseTag := a = "/" || a = "!" || a = "?" || b = "/" )
            StringTrimRight, tabs, tabs, tablen
         XML .= ( OpenTag || PrevCloseTag ? tabs : "" ) "<" A_LoopField
         If !( PrevCloseTag := CloseTag ) * OpenTag
            tabs := ( tabs = "" ? "`n" : tabs ) tab
      }
   Return XML, ErrorLevel := oel
}
