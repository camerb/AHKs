#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll" . " (queued at 2012-05-01_08-53-15)")
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120501085315.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120501085315.ahk")