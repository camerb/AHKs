#include FcnLib.ahk
;http://www.autohotkey.com/forum/topic18033.html
#SingleInstance, Force

Gui, -Caption +Border +AlwaysOnTop +ToolWindow
Gui, Color, EEAA99
Gui, +LastFound
WinSet, TransColor, EEAA99
Gui, Add, Progress,      w100 h10 cGreen -0x1 vDn
Gui, Add, Progress, x+10 w100 h10 cRed   -0x1 vUp
Gui, Show, x780 y3 , NetMeter                  ; Adjust X & Y to suit your screen res

If GetIfTable(tb)
   ExitApp

SetTimer, NetMeter, On, 1000
Return

NetMeter:
dnNew := 0
upNew := 0

GetIfTable(tb)

Loop, % DecodeInteger(&tb)
{
/*  Include this codes to exclude the loopback interface.
   If DecodeInteger(&tb + 4 + 860 * (A_Index - 1) + 516) = 24
      Continue
*/
   dnNew += DecodeInteger(&tb + 4 + 860 * (A_Index - 1) + 552)      ; Total Incoming Octets
   upNew += DecodeInteger(&tb + 4 + 860 * (A_Index - 1) + 576)      ; Total Outgoing Octets
}

dnRate := Round((dnNew - dnOld) / 1024)
upRate := Round((upNew - upOld) / 1024)

GuiControl,, Dn, %dnRate%
GuiControl,, Up, %upRate%

dnOld := dnNew
upOld := upNew
Return


GetIfTable(ByRef tb, bOrder = True)
{
   nSize := 4 + 860 * GetNumberOfInterfaces() + 8
   VarSetCapacity(tb, nSize)
   Return DllCall("iphlpapi\GetIfTable", "Uint", &tb, "UintP", nSize, "int", bOrder)
}

GetIfEntry(ByRef tb, idx)
{
   VarSetCapacity(tb, 860)
   DllCall("ntdll\RtlFillMemoryUlong", "Uint", &tb + 512, "Uint", 4, "Uint", idx)
   Return DllCall("iphlpapi\GetIfEntry", "Uint", &tb)
}

GetNumberOfInterfaces()
{
   DllCall("iphlpapi\GetNumberOfInterfaces", "UintP", nIf)
   Return nIf
}

DecodeInteger(ptr)
{
   Return *ptr | *++ptr << 8 | *++ptr << 16 | *++ptr << 24
}
