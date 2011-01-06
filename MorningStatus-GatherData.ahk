#include FcnLib.ahk

filename=gitExempt\morning_status\%A_ComputerName%.txt

freespace:=DriveSpaceFree("C:\")
totalSpace:=freespace/1000
message=%totalspace% GB free on %A_ComputerName%
FileAppendLine(message, filename)

;TODO if leadCompy()
if (A_ComputerName = "PHOSPHORUS")
{
   size:=dirgetsize("C:\My Dropbox\")
   dropboxSize := size/1000000000
   message=Dropbox: %dropboxSize% of 3 GB used
   FileAppendLine(message, filename)
}

