#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll")
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120425143602.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120425143602.ahk")