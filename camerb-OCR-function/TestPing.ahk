#include FcnLib.ahk
#include thirdParty/cmdret.ahk

joe:=cmdret("ping google.com")
addtotrace(A_ComputerName, A_IsUnicode, A_AHKVersion, joe)

CMDret(CMD)
{
   if RegExMatch(A_AHKversion, "^\Q1.0\E")
   {
      StrOut:=CMDret_RunReturn(cmd)
   }
   else
   {
      VarSetCapacity(StrOut, 20000)
      RetVal := DllCall("cmdret.dll\RunReturn", "astr", CMD, "ptr", &StrOut)
      strget:="strget"
      StrOut:=%StrGet%(&StrOut, 20000, CP0)
   }
   Return, %StrOut%
}
