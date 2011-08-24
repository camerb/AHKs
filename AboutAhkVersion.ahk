;debug info script (version window, aka about window)
;shows what version of ahk the user is running
; i think sinkfaze might have come up with this originally (dist. by camerb)

info :=      "AHK Version:`t" A_AhkVersion
   . "`nUnicode:`t`t" (A_IsUnicode ? "Yes " ((A_PtrSize=8) ? "(64-bit)" : "(32-bit)") : "No")
   . "`nOperating System:`t" (!A_OSVersion ? A_OSType : A_OSVersion)
   . "`nAdmin Rights:`t" (A_IsAdmin ? "Yes" : "No")
MsgBox, 68, Support Information, %info%`n`nWould you like to copy this information to the Clipboard?
IfMsgBox Yes
{
   Clipboard :=   info
   ClipWait
   MsgBox, The information was sent to the Clipboard.
}
return
