#include FcnLib.ahk

DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
;WinClose RemoteWidget.ahk - AutoHotkey  ; Update this to reflect the script's name (case sensitive).

;Close as many as gracefully as we can
WinGet, id, LIST, - AutoHotkey
Loop, %id%
{
   thisID:=id%A_Index%
   ahkIdStr=ahk_id %thisID%
   title:=wingettitle(ahkIdStr)
   if NOT InStr(title, A_ScriptName)
      WinClose, %ahkIdStr%
}

;it couldn't be closed gracefully, we need to kill it
while true
{
   Process, Exist, AutoHotKey.exe
   pid:=ERRORLEVEL
   if NOT pid
      break
   ;PostMessage,0x111,65405,0,,ahk_pid %pid%

   ;if it exists
   Process, Exist, %pid%
   pid:=ERRORLEVEL
   if pid
   {
      ;TODO is there a way to check if this process is this ahk? i don't want suicidal ahks
      Process, Close, %pid%
   }
}

;WinGet, List, List, ahk_class AutoHotkey
;Loop %List%
;{
    ;WinGet, PID, PID, % "ahk_id " List%A_Index%
    ;If ( PID <> DllCall("GetCurrentProcessId") )
    ;{
    ;Wingettitle,name,% "ahk_id " List%A_Index%
    ;;LV_Add("", Name, pid)
    ;debug(pid)
    ;}
;}

;debug("about to run main ahk files again")
;RunAhk("""C:\My Dropbox\AHKs\StartIdleAhks.ahk""", )
Run, C:\My Dropbox\AHKs\StartIdleAhks.ahk, C:\My Dropbox\AHKs
