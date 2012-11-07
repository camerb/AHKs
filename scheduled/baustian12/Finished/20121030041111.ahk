#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-10-30_04-11-11)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20121030041111.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20121030041111.ahk")