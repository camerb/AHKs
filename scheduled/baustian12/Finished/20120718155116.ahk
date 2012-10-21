#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-07-18_15-51-16)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120718155116.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120718155116.ahk")