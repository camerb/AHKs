#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepMinutes(2)
addtotrace("red line - remotely closed VM")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120427170306.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120427170306.ahk")