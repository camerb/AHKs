#include FcnLib.ahk

params=%1%

if InStr(params, "GatherData")
{
   filename=gitExempt\morning_status\drivespace-%A_ComputerName%.txt

   freespace:=DriveSpaceFree("C:\")
   totalSpace:=freespace/1024
   message=%totalspace% GB free on %A_ComputerName%
   FileAppendLine(message, filename)

   if (A_ComputerName = LeadComputer())
   {
      filename=gitExempt\morning_status\drivespace-zzz-%A_ComputerName%.txt
      size:=dirgetsize("C:\My Dropbox\")
      dropboxSize := size / (1024 ** 3)
      message=Dropbox: %dropboxSize% of 3 GB used
      FileAppendLine(message, filename)

      ;SysGet, MonitorCount, MonitorCount
      ;message=The monitor count on Phos is %MonitorCount%
      ;FileAppendLine(message, filename)
   }
}

if InStr(params, "SendMessage")
{
   Loop, gitExempt\morning_status\*.*
   {
      thisFile:=FileRead(A_LoopFileFullPath)
      emailMessage .= thisFile . "`n"
      FileDelete(A_LoopFileFullPath)
   }

   SendEmail("Good Morning: Your AHK Status Briefing", emailMessage)
}
