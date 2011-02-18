#include FcnLib.ahk

time1:=A_TickCount
Sleep, 1500
time2:=A_TickCount
AddToTrace(time2-time1, time1, time2)
