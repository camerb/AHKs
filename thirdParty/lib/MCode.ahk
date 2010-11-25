; Machine code functions: Bit Wizardry by Laszlo
; http://www.autohotkey.com/forum/viewtopic.php?t=21172
MCode(ByRef code, hex) { ; allocate memory and write Machine Code there
   VarSetCapacity(code,StrLen(hex)//2)
   Loop % StrLen(hex)//2
      NumPut("0x" . SubStr(hex,2*A_Index-1,2), code, A_Index-1, "Char")
}