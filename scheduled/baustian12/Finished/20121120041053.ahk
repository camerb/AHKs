#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-11-20_04-10-53)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121120041053.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121120041053.ahk")