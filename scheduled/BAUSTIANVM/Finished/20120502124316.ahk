#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll" . " (queued at 2012-05-02_12-43-16)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120502124316.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120502124316.ahk")