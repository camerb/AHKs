#include FcnLib.ahk

;check which ahks didn't finish

ini=gitExempt/%A_ComputerName%.ini
Loop, C:\My Dropbox\AHKs\*.ahk
{
   time:=IniRead(ini, "RunAhkAndBabysit.ahk", A_LoopFileName)
   if (time <> "ERROR")
   {
      debug(A_LoopFileName, time)
      IniDelete(ini, "RunAhkAndBabysit.ahk", A_LoopFileName)
   }
}
