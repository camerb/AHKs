#include FcnLib.ahk

;Calculate my networth based on all items that we have in our inis

ini := GetPath("NightlyStats.ini")
keylist := IniListAllKeys(ini, "MostRecent")
Loop, parse, keylist, CSV
{
   if (A_LoopField = "NetWorth")
      continue
   ;debug(A_Loopfield)
   netWorth += IniRead(ini, "MostRecent", A_LoopField)
}

;debug(netWorth)
NightlyStats("NetWorth", netWorth)

