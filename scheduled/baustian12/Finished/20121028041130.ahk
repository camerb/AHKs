#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-10-28_04-11-30)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121028041130.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121028041130.ahk")