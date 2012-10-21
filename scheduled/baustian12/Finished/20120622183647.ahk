#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-06-22_18-36-47)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120622183647.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120622183647.ahk")