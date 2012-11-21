#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-11-17_04-11-47)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121117041147.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121117041147.ahk")