#include FcnLib.ahk


MB = 3 ;default ram use?
stepMB = 10
Loop
{
   debug("silent log","Current RAM use", MB)
   VarSetCapacity(%A_Index%,stepMB*1000*1024,1)
   MB += %stepMB%
   sleep 100
}
