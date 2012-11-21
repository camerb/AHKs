#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-11-12_04-11-21)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121112041121.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121112041121.ahk")