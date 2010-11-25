/*
Name: Mango: ClipHist
By: tidbit
Version: 1.0
*/
#SingleInstance force
Title=ClipHist
gui, Default
gui, +AlwaysOnTop
gui, add, ListView, x6 y6 w400 r11 vhist ghist, Window|Clip
Lv_ModifyCol(1, 128)
Lv_ModifyCol(2, 256)
gui, add, text, x6, Current Clipboard:
gui, add, edit, x6 h60 w400 vcurclip, %clipboard%
gui, show, Center , %Title%
Return

hist:
  If A_GuiEvent = DoubleClick
  {
    Lv_GetText(text, A_EventInfo, 2)
    clipboard:=text
  }
Return

OnClipboardChange:
  gui, Default
  Guicontrol, , curclip, %clipboard%

  If regexmatch(clipboard, "^\s*$")                    ; ignore adding if blank
    Return
  WinGetActiveTitle, activetitle
  If (activetitle==title)                              ; ignore own window activity
    return
  Lv_Add("", activetitle, Clipboard)
Return

esc::
guiclose:
  ExitApp

