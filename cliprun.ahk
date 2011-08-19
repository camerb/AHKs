#include FcnLib.ahk

; Fantasy clock based on Kyokusen clock version by TokyoFlash
; http://www.tokyoflash.com/en/watch_museum/tokyoflash/kyokusen/
; Inspired from the topic posted by budRich at
; http://www.autohotkey.com/forum/viewtopic.php?t=75223
; and the script posted by specter333 at
; http://www.autohotkey.com/forum/viewtopic.php?t=75010
; © Drugwash, August 2011

#NoEnv 
#SingleInstance, Force
SetBatchLines, -1
SetControlDelay, -1
SetWinDelay, -1
ListLines, Off
SetFormat, Float, 0.0
DetectHiddenWindows, On
appname := "MyClock"
version=0.0.0.3
iconlocal=%A_ScriptDir%\myclock.ico

Menu, Tray, Tip, %appname% %version%
Menu, Tray, NoStandard
Menu, Tray, Add, Hide clock, cmnContextMenu
Menu, Tray, Default, Hide clock
Menu, Tray, Add
Menu, Tray, Add, Reload, reload
Menu, Tray, Add, Exit, cmnClose

inifile := A_ScriptDir "\" appname ".ini"
IniRead, pos, %inifile%, Preferences, pos, %A_Space%
; 1-Aries 2-Taurus 3-Gemini 4-Cancer 5-Leo 6-Virgo 7-Libra 8-Scorpio 9-Sagittarius 10-Capricorn 11-Aquarius 12-Pisces
zstring := "10 20 11,11 19 12,12 21 1,1 20 2,2 21 3,3 21 4,4 23 5,5 23 6,6 23 7,7 23 8,8 22 9,9 22 10"
pstring := "wx wy ww wh wc tx ty tw th fs fc fw ct tl"
wstring := "103 87 14 16 FFF0A0,87 87 14 16 FFD000,71 87 14 16 FFD000,55 87 14 16 FFD000,39 87 14 16 FFD000,23 87 14 16 FFD000,5 87 16 16 FFD000
,5 71 16 14 FFD000,5 55 16 14 FFD000,5 39 16 14 FFD000,5 23 16 14 FFD000
,5 5 16 16 FFD000,23 5 30 16 FFD000,55 5 30 16 FFD000,87 5 30 16 FFD000,119 5 30 16 FFD000,151 5 16 16 FFD000
,151 23 16 14 FFD000,151 39 16 14 FFD000,151 55 16 14 FFD000,151 71 16 14 FFD000,151 87 16 16 FFD000
,135 87 14 16 FFD000,119 87 14 16 FFD000
,28 24 20 38 FF0000,52 24 20 38 FF0000,76 24 20 38 FF0000,100 24 20 38 FF0000,124 24 20 38 FF0000
,28 66 20 12 80FFFF,50 66 4 12 80FFFF,56 66 4 12 80FFFF,62 66 4 12 80FFFF,68 66 4 12 80FFFF,76 66 44 12 800000     6 FFFFFF  0x200,124 66 20 12 800000     9 FFFFFF  0x200"
off := 0x281414
ff35 := "FFF Galaxy"
ff36 := "Wingdings"
dt=2
FormatTime, st35,, dd MMM
FormatTime, d,, d
FormatTime, dm,, M
st36 := "^"
Gui, 99:-Caption +ToolWindow +LastFound + AlwaysOnTop
Gui, 99:Color, Black, Black
Gui, 99:+Labelcmn
Gui, 99:Add, Progress, x28 y81 w116 h3 Range0-59 -Theme vs
mwID := WinExist()
Gui, 99:Show, %  (pos ? pos : "x100 y100") " w172 h108 NA Hide", %appname%
StringSplit, t, pstring, %A_Space%
Loop, Parse, wstring, CSV
   {
   StringSplit, v, A_LoopField, %A_Space%
   i=
   Loop, %v0%
      {
      if t%A_Index% in ff,st
         {
         j := t%A_Index%
         %j% := v%A_Index%
         continue
         }
      i .= t%A_Index% v%A_Index% A_Space
      }
   i .= "ph" mwID " ix" A_Index
   _buildClock(i, "", st%A_Index%, ff%A_Index%)
   }
hCursM := DllCall("LoadCursor", "UInt", 0, "Int", 32646, "UInt")   ; IDC_SIZEALL
Gui, 99:Show, NA
WinSet, Region, 0-0 R10-10 w172 h108, %appname%
;OnMessage(0xA1, "moveit")
SetTimer, altdate, 2000
SetTimer, time, 999
return

; ix=GUI index, wc=GUI color, wx wy ww wh=GUI coords, wn=GUI name, ph=parent handle,
; st=static text, ff=font face, tx ty tw th=text coords, tl=text goto label, ct=control type

_buildClock(p, wn="", st="", ff="Tahoma")
{
Global tv1, tv2, tv3, tv4, tv5, tv6, tv7, tv8, tv9, tv10, tv11, tv12, tv13, tv14, tv15, tv16, tv17, tv18, tv19, tv20, tv21, tv22, tv23, tv24, tv25, tv26, tv27, tv28, tv29, tv30, tv31, tv32, tv33, tv34, tv35, tv36, tv37, tv38, tv39, tv40
ix=1   ; initialize to 1 so the function wouldn't fail miserably in case there's no GUI index in parameters 
Loop, Parse, p, %A_Space%
   {
   StringLeft, c, A_LoopField, 2
   StringTrimLeft, v, A_LoopField, 2
   %c% := v
   }
wn := wn ? wn : "GUI" ix
Gui, %ix%:-Caption +ToolWindow +LastFound
Gui, %ix%:Margin, 0, 0
Gui, %ix%:Color, %wc%
Gui, %ix%:+Labelcmn
if st OR tl OR tw OR th OR ct
   {
tl := tl ? tl : "moveit"
   if ct
      {
      SetFormat, Integer, H
      ct+=0
      SetFormat, Integer, D
      }
   tx := tx ? tx : "0"
   ty := ty ? ty : "0"
   tw := tw ? tw : ww
   th := th ? th : wh
   Gui, %ix%:Font, s%fs% c%fc% %fw%, %ff%
   if ct=0x10E
   Gui, %ix%:Add, Picture, x%tx% y%ty% w%tw% h%th% %ct% Center BackgroundTrans vtv%ix% g%tl%,%st%
   else
   Gui, %ix%:Add, Text, x%tx% y%ty% w%tw% h%th% %ct% Center BackgroundTrans vtv%ix% g%tl%,%st%
   }
g%ix%ID := WinExist()
Gui, %ix%:Show, x%wx% y%wy% w%ww% h%wh% NA, %wn%
if ix = 7
   WinSet, Region, 0-15 8-0 15-15 0-15, GUI7
if ix = 12
   WinSet, Region, 0-0 15-8 0-15 0-0, GUI12
if ix = 17
   WinSet, Region, 15-0 8-15 0-0 15-0, GUI17
if ix = 22
   WinSet, Region, 15-15 0-8 15-0 15-15, GUI22
if ph
   DllCall("SetParent", "UInt", g%ix%ID, "UInt", ph)
}

reload:
WinGetPos, x, y,,, %appname%
IniWrite, x%x% y%y%, %inifile%, Preferences, pos
reload
cmnClose:
WinGetPos, x, y,,, %appname%
IniWrite, x%x% y%y%, %inifile%, Preferences, pos
ExitApp

cmnContextMenu:
vis := !vis
Menu, Tray, Rename, % (vis ? "Hide" : "Show") " clock", % (vis ? "Show" : "Hide") " clock"
Gui, % "99:" (vis ? "Hide" : "Show")
return

moveit()
{
Global
gosub moveit
}
moveit:
DllCall("SetCursor", "UInt", hCursM)
PostMessage, 0xA1, 2,,, ahk_id %mwID%
return

altdate:
dt := (dt < "2" ? dt+1 : "0")
FormatTime, j,, % dt="0" ? "dddd" : (dt="1" ? "dd MMM" : "yyyy")
if !dt
   StringLeft, j, j, 3
GuiControl, 35:, tv35, %j%
return

time:
FormatTime, h,, H
FormatTime, m,, m
FormatTime, s,, s
if (d != ld)
   Loop, Parse, zstring, CSV
      if (dm=A_Index)
         {
         StringSplit, i, A_LoopField, %A_Space%
         GuiControl, 36:, tv36, % Chr(93+ (d>=i2 ? i3 : i1))
         break
         }
if (h != lh)
   Loop, 24
      Gui, %A_Index%:Color, % (h<A_Index-1 ? off : A_Index=1 ? 0xFFF0A0 : 0xFFD000)
if (m != lm)
   {
   Loop, 5
      Gui, % (A_Index+24 ":Color"), % (m//10 < A_Index ? off : 0xFF0000)
   i := Round(10*(m/10 - m//10))
   Gui, 30:Color, % (i < "5" ? off : 0x80FFFF)
   Loop, 4
      Gui, % (30+A_Index ":Color"), % (( i-5*(i > "4") < A_Index) ? off : 0x80FFFF)
   }
i := s*116//60
GuiControl, 99:, s, %s%
lh := h, lm := m, ls := s
return



 ~esc::ExitApp