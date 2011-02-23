#include FcnLib.ahk

if (A_ComputerName <> "BAUSTIAN-09PC")
{
   ;TODO put this into a function??? fatalIfNotThisPC()
   debug(A_ScriptName, A_ComputerName, "this script isn't designed to run on this pc")
   ExitApp
}

;TODO check if GVIM window already exists?

Run, C:\My Dropbox\Programs\Vim\vim72\gvim.exe, C:\My Dropbox\AHKs
;debug(A_WorkingDir)

ForceWinFocus("GVIM", "Contains")
SendInput, ^!{NUMPAD5}{F2}^w{RIGHT}{;}q{ENTER}
