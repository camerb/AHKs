#include FcnLib.ahk

;close all ahks except those listed

closeAllExceptRegex=%1%
startThisAhkAfterFinished=%2%

DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
;WinClose RemoteWidget.ahk - AutoHotkey  ; Update this to reflect the script's name (case sensitive).

;Close as many as gracefully as we can
WinGet, id, list, - AutoHotkey
Loop, %id%
{
   thisID:=id%A_Index%
   ahkIdStr=ahk_id %thisID%
   title:=wingettitle(ahkIdStr)
   if NOT (InStr(title, A_ScriptName) OR RegExMatch(title, closeAllExceptRegex))
      WinClose, %ahkIdStr%
}

;done with being patient
WinGet, id, list, - AutoHotkey
Loop, %id%
{
   thisID:=id%A_Index%
   ahkIdStr=ahk_id %thisID%
   title:=wingettitle(ahkIdStr)
   ;Process, Exist, %pid%
   ;pid:=ERRORLEVEL
   ;if pid
   ;{
   pid := WinGet(thisID, ahkIdStr)
   if NOT (InStr(title, A_ScriptName) OR RegExMatch(title, closeAllExceptRegex))
   {
      Process, Close, WinClose, %ahkIdStr%
   }
}
