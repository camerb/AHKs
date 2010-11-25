; Authors: Titan, BoBo¨, Metaxal
; GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

/*
   original topic:
   http://www.autohotkey.com/forum/viewtopic.php?t=23671

   Version history:
    
    - 0.17m (Metaxal)
        - bugfix: moverel now moves the mouse relatively to the initial mouse coordinates
        - added "WAIT!" message 
        - (bug) added var gui_windowrel, to move in Coordmode Relative, NOT YET FUNCTIONAL!
            added gui control
            (Russian and German traductions for this are approximate)
    - 0.16m (Metaxal)
        - added: Russian text by Anton Bukov
   - 0.15m (Metaxal)
      - added: ExitApp key in generated scripts (the same key as the one used to stop recording, which makes sense!)
      - added NumpadEnter as bug key
      - added Replay button, script saved by default in temp.ahk
   - 0.14m (Metaxal)
      - fixed: buggy keys (Delete, Home, PgUp, ...) not logged
      - fixed: recording mouse moves was not functional?
      - not tested: relative mouse moves
   - 0.13m (Metaxal)
      - fixed: mouse clicks not recorded relative to screen...
      - Using VK codes instead of explicit symbols
         -> no problem whatever the foreign keyboard?
         -> can handle mysterious keys !
         -> handles mouse up and down + joysticks (?)
   - 0.12m (Metaxal)
      - french translation
      - removed consolidate, added add_log
      -> no need for #Include grep.ahk anymore. Multiple "Sends" are still merged, but "aaaa" is no more compressed
      -> also corrects the "Sl{e 2}p" error
      - added WinWait, IfWinActive and WinWaitActive
      - F11 and F12 for start/stop prefered to avoid some bugs with combined hotkeys
      - fixed: WinActivate not detected (wParam=32772)
      - fixed: "Send, " without parameter was added at end of script
      - fixed: mouse cordinates not relative or absolute
      - fixed(?): pressing Shift or Control at beginning of script would go to some other hotkey label
      (sometimes stop, sometimes start, or even exit when *~Esc is active)
      resolved by placing the call to hotkeys() before initializing the start and stop hotkeys
      Not sure this is completely fixed
      - fixed: wrong Sleep times
      - fixed: Sleep not initialized at each new recording
      - NOT fixed: keys are sometimes missed, and sometimes added??
      
   - 0.11a
      Original version by Titan, german translations by BoBo¨
*/

/*
   TODO:
   - Add a tooltip in the generated script to show when the script is playng or is ended.
*/

#SingleInstance ignore
#NoEnv
#NoTrayIcon

#Include %A_ScriptDir% ; Metaxal: Ensures a consistent #Include directory
#Include Anchor.ahk
; #Include grep.ahk ; Metaxal: not needed anymore

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetBatchLines, -1
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen

lang_table =
( Join`n `
en,de,fr,ru
Recorder by Titan,Titans Makro Recorder, Enregistreur de macro par Titan,????????? ???????? Titan-?
Recording options,Aufnahmeoptionen,Options d'enregistrement,????? ??????
&Time intervals,&Zeitintervalle,&Intervalles de temps,????????? ?????????
&Window actions,&Fensteraktionen,&Gestion des fenetres,???????? ??? ??????
&Use control commands,&Control-Befehle,&Commandes de controle,???????? ??? ?????????? ??????????
&Keyboard actions,&Tastaturaktionen,C&lavier,??????? ??????
Mouse c&licks,&Mausklicks,Clics &souris,????? ??????
&Movements,&Bewegungen,&Mouvements,????????
Rel,Rel,Rel,??
Hotkeys,Hotkeys,Hotkeys,??????? ???????
S&tart,St&art,&Debut,?????
St&op,St&op,&Fin,????
&Save As...,&Speichern unter...,&Enregistrer sous...,????????? ???...
&Clear,Z&urucksetzen,&Effacer,????????
Macro,Makro,Macro,??????
Save As...,Speichern unter...,Enregistrer sous...,????????? ???...
AutoHotkey Scripts,AutoHotkey Scripts,AutoHotkey Scripts?AutoHotkey ???????
Recording macro...`nPress $1 to stop.,Makroaufzeichnung...`nBeenden mit $1,Enregistrement en cours...`nAppuyez sur $1 pour arreter,?????? ???????... `n??? ????????? ??????? $1
"Loading script, please wait...","Lade Skript, bitte warten...","Chargement du script, veuillez patienter..."?"?????? ???????????..."
Save script,Skript speichern,Enregistrer le script,????????? ??????
Would you like to save the current script before closing?,Vor Beenden speichern?,Enregistrer avant de quitter ?,????????? ??????????
Replay,Abspiel,Rejouer,?????????
WAIT!, WARTEN!, ATTENDEZ !, ?????!
Window Rel, Fenster Rel, Rel Fenetre, ?? ????????? ? ????
)

If A_Language in 0407,0807,0c07,1007,1407
   lang = de
Else If A_Language in 040c,080c,0c0c,100c,140c,180c
   lang = fr
Else If A_Language in 0409
   lang = ru
Else lang = en ; default

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
vers = 0.14m
config = %A_AppData%\%title%.ini
config_list = clicks,keyboard,window,ctrl,sleep,movements=0,movint=10,moveinte=10,moverel=0,start=F11,stop=F12,play=F9,windowrel=0
Loop, Parse, config_list, `,
{
   StringSplit, v, A_LoopField, =
   IniRead, gui_%v1%, %config%, Options, %v1%, % InStr(A_LoopField, "=") ? v2 : 1
}

Gui, +Resize +MinSize +LastFound
; fixed width font is too big
Gui, Add, Edit, vscr Hwndhscr w350 h200 gType
Gui, Font
Gui, Add, GroupBox, vsec1 Section ym w200 r7.5, %lang2%
Gui, Add, CheckBox, vgui_sleep xp+15 yp+25 Checked%gui_sleep%, %lang3%
Gui, Add, CheckBox, vgui_window Checked%gui_window%, %lang4%
Gui, Add, CheckBox, vgui_ctrl Checked%gui_ctrl% Disabled, %lang5%
Gui, Add, CheckBox, vgui_keyboard Checked%gui_keyboard%, %lang6%
Gui, Add, CheckBox, vgui_clicks Checked%gui_clicks%, %lang7%
Gui, Add, CheckBox, vgui_movements Checked%gui_movements% gMov, %lang8%
Gui, Add, Edit, vgui_moveinte xp+85 yp-2 w50 Limit4
Gui, Add, UpDown, vgui_movint Range1-5000, %gui_movint%
Gui, Add, CheckBox, vgui_moverel xp-60 yp+25 Checked%gui_moverel%, %lang9% ;xp+60 yp+2 
Gui, Add, CheckBox, vgui_windowrel xp+40 yp Checked%gui_windowrel%, %lang24% ;xp-60 yp+20 
Gui, Add, GroupBox, vsec2 xs w200 r5, %lang10%
Gui, Add, Text, vlbl1 xp+15 yp+25, %lang11%:
Gui, Add, Hotkey, vgui_start xp+40 yp-2 Limit1 gHotkey, %gui_start%
Gui, Add, Text, vlbl2 xp-40 yp+27, %lang12%:
Gui, Add, Hotkey, vgui_stop xp+40 yp-2 Limit1 gHotkey, %gui_stop%
Gui, Add, Text, vlbl4 xp-40 yp+29, %lang22%:
Gui, Add, Hotkey, vgui_play xp+40 yp-2 Limit1 gHotkey, %gui_play%
Gui, Add, Button, vsave Section xm yp+10 Disabled gSave, %lang13%
Gui, Add, Button, vclear ys w55 Disabled gClear, %lang14%
Gui, Add, Button, vlbl3 xm+295 ys w55 Default gStart, %lang11%
Gui, Show, , %lang1% (v%vers%)

SendMessage, 208, 0, RegisterCallback("EditWordBreakProc"), , ahk_id %hscr%

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
GuiControlGet, v, , gui_play
If v !=
   Hotkey, %v%, PlayTemp
Return

;;; END OF AUTO-EXECUTE SECTION ;;; 

GuiSize:
Anchor("scr", "wh")
v = sec1,gui_movint,gui_clicks,gui_keyboard,gui_window,gui_ctrl,gui_sleep,gui_movements,gui_movint,gui_moverel,sec2,lbl1,gui_start,lbl2,gui_stop,gui_play,lbl4,gui_moveinte,gui_windowrel
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
ToolTip, %lang23%, 5, 5
hotkeys(true) ; Metaxal: needs to be BEFORE setting gui_start and gui_stop??
Gosub, Hotkey
GuiControlGet, v, FocusV
If v in gui_start,gui_stop
   Return
GuiControlGet, v, , gui_stop
StringReplace, s, lang18, $1, %v%
StringReplace, s, s, ``n, `n
Gui, Submit
GuiControlGet, gui_movint, , gui_moveinte
log_mpx := 0
log_mpy := 0
log_s = 1
log_xt := A_TickCount ; Initialize sleep counter
last_cmd=
log_text=
log_text .= "#NoEnv`n" ; SendMode Input`n" ; buggy with mousemove! (not synchronous)
add_log("CoordMode", "Mouse, " . (gui_windowrel ? "Relative" : "Screen"))
if gui_windowrel ; Not yet functional!
   CoordMode, Mouse, Relative
else
   CoordMode, Mouse, Screen
add_log("SetMouseDelay",  "2")   

If (gui_movements and gui_movint > 0 and gui_movint <= 5000) {
   ;MsgBox timer=%gui_movint%
   SetTimer, MouseMov, %gui_movint%
   }

ToolTip, %s%, 5, 5

;Loop {
;   Input, v, L1 V ; now useless
;   logkey(v)
;   If !log_s
;      Break
;}

Return

Stop:
log_s = 0
ToolTip, %lang19%, 5, 5
;Input
SetTimer, MouseMov, Off
hotkeys(false)
Gui, Show
ToolTip
GuiControlGet, v, , log_text
If v
   v .= "`n"
log_text .= "`nExitApp`n" . gui_stop . "::ExitApp`n" ; the exit key is the one used to stop the script!
FileDelete temp.ahk
FileAppend %log_text%, temp.ahk
GuiControl, , scr, %v%%log_text%
VarSetCapacity(log_text, 0)
ControlSend, , ^{End}, ahk_id %hscr%
Goto, Type
Return

LogKey:
If log_s {
   StringTrimLeft, v, A_ThisHotkey, 2 ; -2 to remove "~*"
   logkey(v)
}
Return

MouseMov:
   MouseGetPos, x, y
   If (x != log_mpx or y != log_mpy) {
      If gui_moverel
         add_log("MouseMove ", (log_mpx ? x - log_mpx : 0) . ", " . (log_mpy ? y - log_mpy : 0) . ",, R")
      Else 
         add_log("MouseMove", x . ", " . y)
   }
         
   log_mpx := x
   log_mpy := y

Return

PlayTemp:
   Run %A_AhkPath% temp.ahk
Return

;~*Esc:: ; for debugging
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

; Metaxal
add_log(cmd, params) {
   global last_cmd, log_text, log_xt, gui_sleep, log_xt

   If gui_sleep and (cmd != "Sleep") {
      v := Round((A_TickCount - log_xt) / 1)
      If (log_text and v > 700)
         add_log("Sleep", v) ; 
      log_xt := A_TickCount
   }

   If (SubStr(cmd, 1, 4) = "Send") and (cmd = last_cmd)
      log_text .= params
   Else
      log_text .= "`n" . cmd . ", " . params
   
   last_cmd = %cmd%
}

logkey(v) {
   local _w, _ct
   
   k := SubStr(v, 1, 4)
   if v not contains up
      v = %v% down
   v = {%v%}
   
   ; VK codes can also detect mouse down and up !!
   if k in VK01,VK02,VK04 ; mouse clicks
   {
      If gui_clicks {
         GoSub MouseMov
         add_log("Send", v) ; Synchronous click
      }
   }
   Else If gui_keyboard {
      add_log("SendInput", v)
   }
}

ShellMessage(wParam, lParam) {
   local t, c
   ;If wParam = 4 ; HSHELL_WINDOWACTIVATED
   If (wParam = 32772) or (wParam = 4) ; HSHELL_RUDEAPPACTIVATED or HSHELL_WINDOWACTIVATED
   {
      WinGetTitle, t, ahk_id %lParam%
      WinGetClass, c, ahk_id %lParam%
      If (log_s and gui_window and t and c) {
         d := t . " ahk_class " . c
         ;add_log("WinWait", d)
         add_log("IfWinNotActive", d . ", , WinActivate, " . d)
         add_log("WinWaitActive", d)
      }
   }
}

hotkeys(on = true) {

   ; VK codes seem to be much more reliable concerning different keyboard configurations.
   ; also handles properly the down and up of several keys, even mouse ones.
   ; also handles joysticks ?!
   
   ; This should allow for *any* foreign keyboard (?)
   ; although it is not very readable, so the script cannot really be modified manually
   nums=0123456789ABCDEF
   StringSplit numarray, nums

   Loop %numarray0%
   {
      n1 := numarray%A_Index%
      Loop %numarray0%
      {
         n2 := numarray%A_Index%
         n := n1 . n2
         if n=00
            continue
         k := "*~VK" . n
         Hotkey, %k%, LogKey, % "B" . (on ? "On" : "Off") ;%
         Hotkey, %k% up, LogKey, % "B" . (on ? "On" : "Off") ;%
      }
   }
   
   bugkeys=Delete,Home,PgUp,PgDn,Insert,End,NumpadEnter
   Loop, Parse, bugkeys, `,
   {
      k =  ~*%A_LoopField%
      Hotkey, %k%, LogKey, % "B" . (on ? "On" : "Off") ;%
      Hotkey, %k% up, LogKey, % "B" . (on ? "On" : "Off") ;%
   }
   
}

; taken from http://www.autohotkey.com/forum/topic20337.html
EditWordBreakProc(lpch, ichCurrent, cch, code) {
   static exp = "\W" ; treat any non alphanumeric character as a delimiter with this regex
   Loop, % cch * 2 ; build the string: ;%
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