#include FcnLib.ahk

while true
{
   Process, Exist, AutoHotKey.exe
   pid:=ERRORLEVEL
   if NOT pid
      break
   debug(pid)
   ;Sleep, 1000
   PostMessage,0x111,65405,0,,ahk_pid %pid%
   Process, WaitClose, %pid%, 1
   Process, Exist, %pid%
   pid:=ERRORLEVEL
   if pid
   {
      debug("closing")
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

;debug("about to run main ahk file again")
Run, AutoHotKey.ahk
