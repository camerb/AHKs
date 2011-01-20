#include FcnLib.ahk

;apparently the Dropbox exe is in the A_AppData folder

Process, Close, Dropbox.exe
SleepSeconds(5)
RunProgram("C:\Documents and Settings\Baustian\Application Data\Dropbox\bin\Dropbox.exe")
