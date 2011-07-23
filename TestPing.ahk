#include FcnLib.ahk
#include thirdParty/cmdret.ahk

joe:=cmdret("ping google.com")
addtotrace(A_ComputerName, A_IsUnicode, A_AHKVersion, joe)

CMDret(CMD)
{
   if InStr(A_AHKversion, "1.0")
      StrOut:=CMDret_RunReturn(cmd)
   else
   {
      VarSetCapacity(StrOut, 20000)
      RetVal := DllCall("thirdParty\camerb-OCR-function\cmdret.dll\RunReturn", "astr", CMD, "ptr", &StrOut)
      strget:="strget"
      StrOut:=%StrGet%(&StrOut, 20000, CP0)
   }
   Return, %StrOut%
}
