#include FcnLib.ahk

;TODO check if GVIM window already exists?

Run, C:\Dropbox\Programs\Vim\vim72\gvim.exe, C:\Dropbox\AHKs
;debug(A_WorkingDir)

ForceWinFocus("GVIM", "Contains")
SendInput, ^!{NUMPAD5}{F2}
