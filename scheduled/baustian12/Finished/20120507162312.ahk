#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM" . " (queued at 2012-05-07_16-23-12)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120507162312.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120507162312.ahk")