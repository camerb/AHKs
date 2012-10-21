#include FcnLib.ahk


addtotrace("yellow line - remote ForceReloadAll (queued at 2012-06-13_08-46-52)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120613084652.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120613084652.ahk")