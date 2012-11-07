#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-10-29_04-10-34)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121029041034.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121029041034.ahk")