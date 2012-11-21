#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-11-14_04-13-10)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121114041310.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121114041310.ahk")