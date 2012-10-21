#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-05-25_18-32-19)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120525183219.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120525183219.ahk")