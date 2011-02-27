#include FcnLib.ahk

filename=gitExempt\morning_status\%A_ComputerName%.txt

freespace:=DriveSpaceFree("C:\")
totalSpace:=freespace/1024
message=%totalspace% GB free on %A_ComputerName%
FileAppendLine(message, filename)

;TODO if leadCompy()
if (A_ComputerName = "PHOSPHORUS")
{
   size:=dirgetsize("C:\My Dropbox\")
   d := 1024 * 3
   dropboxSize := size / (1024 * 3)
   dropboxSize := size / d
   dropboxSize2 := size/1000000000
   message=Dropbox: %dropboxSize% %dropboxSize2% of 3 GB used
   FileAppendLine(message, filename)

   SysGet, MonitorCount, MonitorCount
   message=The monitor count on Phos is %MonitorCount%
   FileAppendLine(message, filename)
}

