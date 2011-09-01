#include FcnLib.ahk

fatalIfNotThisPC("BAUSTIAN-09PC")

Process, Exist, WinSplit.exe
if NOT ErrorLevel
   RunProgram("WinSplit.exe")

;TODO check if GVIM window already exists?
;Process, Exist, gvim.exe
;if ErrorLevel
   ;ExitApp

Run, C:\Dropbox\Programs\Vim\vim72\gvim.exe, C:\Dropbox\AHKs
;debug(A_WorkingDir)

ForceWinFocus("GVIM", "Contains")
SendInput, ^!{NUMPAD5}{F2}^w{RIGHT}{;}q{ENTER}
