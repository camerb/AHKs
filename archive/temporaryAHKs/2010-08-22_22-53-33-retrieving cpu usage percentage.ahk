#include FcnLib.ahk
#Persistent
SetTimer, ShowToolTip

ShowToolTip:
   Process, Exist, Chrome.exe
   ;debug(ERRORLEVEL)
   ProcessUsage := GetCpuUsage(ERRORLEVEL)
   if (ProcessUsage > 1)
      debug(ProcessUsage)
Return

;CoordMode, ToolTip, Screen

;Process, Exist, Chrome.exe
;PID := errorLevel
;IfEqual, PID, 0, ExitApp
;SetTimer, ShowToolTip
;Return

;ShowToolTip:
 ;PrLoad := Round( GetCpuUsage(PID),2)
 ;ToolTip %PrLoad%`%, 10,10
;Return

GetCpuUsage( PID )    {
   Static oldKrnlTime, oldUserTime
   Static newKrnlTime, newUserTime

   oldKrnlTime := newKrnlTime
   oldUserTime := newUserTime

   hProc := DllCall("OpenProcess", "Uint", 0x400, "int", 0, "Uint", pid)
   DllCall("GetProcessTimes", "Uint", hProc, "int64P", CreationTime, "int64P", ExitTime, "int64P", newKrnlTime, "int64P", newUserTime)

   DllCall("CloseHandle", "Uint", hProc)
   Return Round( (newKrnlTime-oldKrnlTime + newUserTime-oldUserTime)/10000000 * 100 ,2)
}

