#include FcnLib.ahk


ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at 2012-09-24_04-10-46)")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Running\20120924041046.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIAN12\Finished\20120924041046.ahk")