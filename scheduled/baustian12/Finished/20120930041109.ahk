#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-09-30_04-11-09)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120930041109.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120930041109.ahk")