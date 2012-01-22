#include FcnLib.ahk

;FIXME I don't really like the way I did this anymore...
;I'm thinking that I should split this into two AHKs... one called "GetFileSystemStats"
;and the other can stay named "MorningStatus"

params=%1%

if InStr(params, "GatherData")
{
   filename=gitExempt\morning_status\drivespace-%A_ComputerName%.txt

   freespace:=DriveSpaceFree("C:\")
   totalSpace:=freespace/1024
   message=%totalspace% GB free on %A_ComputerName%

   if (totalSpace < 5 AND A_ComputerName = "BAUSTIAN-09PC")
      shouldWrite := true
   if (totalSpace < 10 AND A_ComputerName = "PHOSPHORUS")
      shouldWrite := true
   if (totalSpace < 0.85 AND A_ComputerName = "phosphorusVM")
      shouldWrite := true
   if (totalSpace < 2 AND A_ComputerName = "T-800")
      shouldWrite := true

   if shouldWrite
      FileAppendLine(message, filename)

   if (A_ComputerName = LeadComputer())
   {
      filename=gitExempt\morning_status\drivespace-zzz-%A_ComputerName%.txt
      size:=dirgetsize("C:\Dropbox\")
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
