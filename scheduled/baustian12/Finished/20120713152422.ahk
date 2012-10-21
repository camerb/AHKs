#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-07-13_15-24-22)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120713152422.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120713152422.ahk")