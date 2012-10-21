#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-09-25_04-10-57)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120925041057.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120925041057.ahk")