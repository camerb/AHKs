; by Titan; German translations by BoBo¨
; GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

#SingleInstance ignore
#NoEnv
#NoTrayIcon
#Include Anchor.ahk
#Include grep.ahk

SetBatchLines, -1
CoordMode, ToolTip, Screen

lang_table =
( Join`n `
en,de
Recorder by Titan,Titans Makro Recorder
Recording options,Aufnahmeoptionen
&Time intervals,&Zeitintervalle
&Window actions,&Fensteraktionen
&Use control commands,&Control-Befehle
&Keyboard actions,&Tastaturaktionen
Mouse c&licks,&Mausklicks
&Movements,&Bewegungen
Rel,Rel
Hotkeys,Hotkeys
S&tart,St&art
St&op,St&op
&Save As...,&Speichern unter...
&Clear,Z&urücksetzen
Macro,Makro
Save As...,Speichern unter...
AutoHotkey Scripts,AutoHotkey Scripts
Recording macro...`nPress $1 to stop.,Makroaufzeichnung...`nBeenden mit $1
"Loading script, please wait...","Lade Skript, bitte warten..."
Save script,Skript speichern
Would you like to save the current script before closing?,Vor Beenden speichern?
)

If A_Language in 0407,0807,0c07,1007,1407
	lang = de
Else lang = en ; default

;lang = de
i = -1
Loop, Parse, lang_table, `n
{
	i++
	Loop, Parse, A_LoopField, CSV
	{
		If i = 0
		{
			If lang = %A_LoopField%
				j = %A_Index%
		}
		Else If A_Index = %j%
		{
			lang%i% = %A_LoopField%
		}
	}
}
;listvars

title = Recorder
vers = 0.11a
config = %A_AppData%\%title%.ini
config_list = clicks,keyboard,window,ctrl,sleep,movements=0,movint=300,moverel=0,start=^+s,stop=^+e
Loop, Parse, config_list, `,
{
	StringSplit, v, A_LoopField, =
	IniRead, gui_%v1%, %config%, Options, %v1%, % InStr(A_LoopField, "=") ? v2 : 1
}

Gui, +Resize +MinSize +LastFound
; fixed width font is too big
/*Gui, Font, , Courier
Gui, Font, , Courier New
Gui, Font, , Andale Mono
Gui, Font, s10
*/
Gui, Add, Edit, vscr Hwndhscr w350 h200 gType
Gui, Font
Gui, Add, GroupBox, vsec1 Section ym w200 r6.5, %lang2%
Gui, Add, CheckBox, vgui_sleep xp+15 yp+25 Checked%gui_sleep%, %lang3%
Gui, Add, CheckBox, vgui_window Checked%gui_window%, %lang4%
Gui, Add, CheckBox, vgui_ctrl Checked%gui_ctrl% Disabled, %lang5%
Gui, Add, CheckBox, vgui_keyboard Checked%gui_keyboard%, %lang6%
Gui, Add, CheckBox, vgui_clicks Checked%gui_clicks%, %lang7%
Gui, Add, CheckBox, vgui_movements Checked%gui_movements% gMov, %lang8%
Gui, Add, Edit, vgui_moveinte xp+85 yp-2 w50 Limit4
Gui, Add, UpDown, vgui_movint Range100-5000, %gui_movint%
Gui, Add, CheckBox, vgui_moverel xp+60 yp+2 Checked%gui_moverel%, %lang9%
Gui, Add, GroupBox, vsec2 xs w200 r3, %lang10%
Gui, Add, Text, vlbl1 xp+15 yp+25, %lang11%:
Gui, Add, Hotkey, vgui_start xp+40 yp-2 Limit1 gHotkey, %gui_start%
Gui, Add, Text, vlbl2 xp-40 yp+27, %lang12%:
Gui, Add, Hotkey, vgui_stop xp+40 yp-2 Limit1 gHotkey, %gui_stop%
Gui, Add, Button, vsave Section xm yp+10 Disabled gSave, %lang13%
Gui, Add, Button, vclear ys w55 Disabled gClear, %lang14%
Gui, Add, Button, vlbl3 xm+295 ys w55 Default gStart, %lang11%
Gui, Show, , %lang1% (v%vers%)

SendMessage, 208, 0, RegisterCallback("EditWordBreakProc"), , ahk_id %hscr%

keys_mouse = LButton,RButton,MButton,WheelDown,WheelUp,XButton1,XButton2
keys = %keys_mouse%
	,Space,Tab,Enter,Escape,Backspace
	,Delete,Insert,Home,End,PgUp,PgDn,Up,Down,Left,Right
	,ScrollLock,CapsLock,NumLock
	,Numpad0,NumpadIns,Numpad1,NumpadEnd,Numpad2,NumpadDown,Numpad3,NumpadPgDn,Numpad4,NumpadLeft,Numpad5,NumpadClear,Numpad6,NumpadRight
	,Numpad7,NumpadHome,Numpad8,NumpadUp,Numpad9,NumpadPgUp,NumpadDot,NumpadDel,NumpadDiv,NumpadDiv,NumpadMult,NumpadMult
	,NumpadAdd,NumpadAdd,NumpadSub,NumpadSub,NumpadEnter,NumpadEnter
	,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24
	,AppsKey,LWin,RWin,Control,Ctrl,Alt,Shift
	,LControl,LCtrl,RCtrl,Ctrl,LShift,RShift,LAlt,RAlt
	,PrintScreen,CtrlBreak,Pause,Break
	,Help,Sleep
	,Browser_Back,Browser_Forward,Browser_Refresh,Browser_Stop,Browser_Search,Browser_Favorites,Browser_Home
	,Volume_Mute,Volume_Down,Volume_Up,Media_Next,Media_Prev,Media_Stop,Media_Play_Pause
	,Launch_Mail,Launch_Media,Launch_App1,Launch_App2
	; to prevent issues with foreign keyboards use Input command instead:
	;,q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,1,2,3,4,5,6,7,8,9,0
	;,¬,!,",£,$,`%,^,&,*,(,),_,+,.,{,},:,@,~,<,>,?,|,``,¦,/,;,',#,[,]

;OnExit, GuiClose ; already handled by GuiClose - the only exit point

GoSub, Mov

; adapted from Skan's script at http://www.autohotkey.com/forum/viewtopic.php?p=123323#123323:
DllCall("RegisterShellHookWindow", "UInt", WinExist())
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), "ShellMessage")

Hotkey:
GuiControlGet, v, , gui_start
If v !=
	Hotkey, %v%, Start
GuiControlGet, v, , gui_stop
If v !=
	Hotkey, %v%, Stop
Return

GuiSize:
Anchor("scr", "wh")
v = sec1,gui_movint,gui_clicks,gui_keyboard,gui_window,gui_ctrl,gui_sleep,gui_movements,gui_moveinte,gui_moverel,sec2,lbl1,gui_start,lbl2,gui_stop
Loop, Parse, v, `,
	Anchor(A_LoopField, "x", true)
Anchor("save", "y")
Anchor("clear", "xy")
Anchor("lbl3", "xy")
Return

Mov:
GuiControlGet, v, , gui_movements
GuiControl, Enable%v%, gui_moveinte
GuiControl, Enable%v%, gui_moverel
Return

Clear:
;GuiControl, , scr
ControlSend, , ^{Home}^+{End}{Del}, ahk_id %hscr% ; this allows undo
Type:
GuiControlGet, scr, , scr
v := StrLen(scr) > 0
GuiControl, Enable%v%, save
GuiControl, Enable%v%, clear
unsaved := true
Return

Save:
GuiControlGet, scr, , scr
Gui, +OwnDialogs
FormatTime, d, , ShortDate
FormatTime, t, , Time
StringReplace, t, t, :, .
StringReplace, d, d, /, -, All
FileSelectFile, file, S19, %A_MyDocuments%\%lang15% %d% %t%.ahk, %lang13%, %lang17% (*.ahk; *.txt)
If file =
	Return
FileDelete, %file%
FileAppend, %scr%, %file%
unsaved := false
VarSetCapacity(scr, 0)
Return

Start:
Gosub, Hotkey
GuiControlGet, v, FocusV
If v in gui_start,gui_stop
	Return
log_s = 1
GuiControlGet, v, , gui_stop
StringReplace, s, lang18, $1, %v%
StringReplace, s, s, ``n, `n
ToolTip, %s%, 5, 5
Gui, Submit
hotkeys(true)
GuiControlGet, gui_movint, , gui_movint
If (gui_movements and gui_movint >= 100 and gui_movint <= 5000)
	SetTimer, MouseMov, %gui_moveint%
Loop {
	Input, v, L1 V
	logkey(v)
	If !log_s
		Break
}
Return

Stop:
log_s = 0
ToolTip, %lang19%, 5, 5
Input
SetTimer, MouseMov, Off
hotkeys(false)
Gui, Show
ToolTip
StringGetPos, v, log_text, `n, R1
StringLeft, log_text, log_text, v
log_text := SubStr(consolidate(log_text), 3)
GuiControlGet, v, , log_text
If v
	v .= "`n"
GuiControl, , scr, %v%%log_text%
VarSetCapacity(log_text, 0)
ControlSend, , ^{End}, ahk_id %hscr%
Goto, Type
Return

LogKey:
If log_s {
	StringTrimLeft, v, A_ThisHotkey, 2
	logkey(v)
}
Return

MouseMov:
If log_s {
	MouseGetPos, x, y
	If (x != log_mpx or y != log_mpy) {
		If gui_moverel
			log_text .= "`nClick rel " . (log_mpx ? x - log_mpx : x) . " " . (log_mpy ? y - log_mpy : y)
		Else log_text .= "`nClick " . x . " " . y
	}
	log_mpx := x
	log_mpy := y
}
Return

~*Esc:: ; for debugging
GuiClose:
GuiControlGet, scr, , scr
If (scr != "" and unsaved)
{
	Gui, +OwnDialogs
	MsgBox, 20, %lang20%, %lang21%
	IfMsgBox, Yes
		Gosub, Save
}
Gui, Submit
Loop, Parse, config_list, `,
{
	StringSplit, v, A_LoopField, =
	IniWrite, % gui_%v1%, %config%, Options, %v1%
}
ExitApp

logkey(v) {
	local _w, _ct
	If log_s {
		If v in %keys_mouse%
		{
			If gui_clicks {
				MouseGetPos, vx, vy
				If v = RButton
					v = right
				Else If v = MButton
					v = middle
				Else v =
				/*MouseGetPos, , , _w, _ct
				If _ct !=
					log_text .= "`nControlClick, " . _ct . ", " . _w . (v ? ", " . v : "")
				
				Else 
				*/
				log_text .= "`nClick " . (v ? v . " " : "") . vx . " " . vy
			}
		}
		Else {
			If gui_keyboard {
				If StrLen(v) > 1
					v = {%v%}
				Else If v is not alnum
					v = {%v%}
				/*If gui_ctrl {
					WinGetTitle, _w, A
					ControlGetFocus, _ct, A
					If (_ct and _w)
						log_text .= "`nControlSend, " . _ct . ", " . v . ", " . _w
					Else log_text .= "`nSend, " . v
				}
				Else 
				*/
				log_text .= "`nSend, " . v
			}
		}
		If gui_sleep {
			v := Round((A_TickCount - log_xt) / 1)
			If (log_text and v > 700)
				log_text .= "`nSleep, " . v
			log_xt := A_TickCount
		}
	}
}

ShellMessage(wParam, lParam) {
	local t, c
	If wParam = 4 ; HSHELL_WINDOWACTIVATED
	{
		WinGetTitle, t, ahk_id %lParam%
		WinGetClass, c, ahk_id %lParam%
		If (log_s and gui_window and t and c)
			log_text .= "`nWinActivate, " . t . " ahk_class " . c
	}
}

hotkeys(on = true) {
	global keys, keys_mouse
	Loop, 2 {
		Loop, Parse, keys, `,, `r	  `n
			If (state == " up" and InStr(keys_mouse, A_LoopField))
				Continue
			Else Hotkey, *~%A_LoopField%%state%, LogKey, % on ? "On" : "Off"
		state := " up"
	}
}

; taken from http://www.autohotkey.com/forum/topic20337.html
EditWordBreakProc(lpch, ichCurrent, cch, code) {
	static exp = "\W" ; treat any non alphanumeric character as a delimiter with this regex
	Loop, % cch * 2 ; build the string:
		str .= Chr(*(lpch - 1 + A_Index))
	If code = 0 ; WB_LEFT
	{
		; reverse and return last match:
		StringMid, str, str, 1, --ichCurrent
		Loop, Parse, str
			rev := A_LoopField . rev
		Return, ichCurrent - RegExMatch(rev, exp, "[^" . exp . "]+$") + 1
	}
	Else If code = 1 ; WB_RIGHT
		Return, ichCurrent >= cch ? cch : RegExMatch(str, exp, "", ichCurrent + 1) - 1
	Else If code = 2 ; WB_ISDELIMITER
		Return, RegExMatch(SubStr(str, ichCurrent, 1), exp)
}

consolidate(v) {
	Loop, Parse, v, `n
	{
		StringGetPos, xp, A_LoopField, `,
		StringLeft, xc, A_LoopField, xp
		StringTrimLeft, xa, A_LoopField, xp + 2
		If xc = Send
			xsk .= xa
		Else {
			If xsk
				xn .= "`nSend, " . xsk, xsk := ""
			xn .= "`n" . A_LoopField 
		}
	}
	xn .= "`nSend, " . xsk, xsk := ""
	xn := RegExReplace(xn, "i)(\{?(\S+)\}?)\{\2 up\}", "$1")
	Loop, Parse, xn, `n
	{
		StringLeft, xc, A_LoopField, InStr(A_LoopField, ",") - 1
		If xc != Send
			Continue
		grep(A_LoopField, "(\{.*?\})\1+|(.)\2+", xr)
		Loop, Parse, xr, 
		{
			StringGetPos, xp, A_LoopField, }
			If ErrorLevel
				StringReplace, xn, xn, %A_LoopField%, % "{" . SubStr(A_LoopField, 1, 1) . " " . StrLen(A_LoopField) . "}", All
			Else {
				StringReplace, x, A_LoopField, }, }, UseErrorLevel
				xc := ErrorLevel
				StringLeft, xa, A_LoopField, xp
				StringReplace, xn, xn, %A_LoopField%, %xa% %xc%}, All
			}
		}
	}
	Return, xn
}
