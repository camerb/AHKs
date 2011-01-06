#include FcnLib.ahk

Loop, gitExempt\morning_status\*.*
{
   thisFile:=FileRead(A_LoopFileFullPath)
   emailMessage .= thisFile . "`n"
   FileDelete(A_LoopFileFullPath)
}

SendEmail("Good Morning: Your AHK Status Briefing", emailMessage)
