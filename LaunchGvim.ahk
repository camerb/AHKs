#include FcnLib.ahk

;exit if this computer shouldn't run this macro
if (A_ComputerName = "BAUSTIAN12")
{
}
else if (A_ComputerName = "T-800")
{
}
else if (A_ComputerName = "SEWING-XP")
{
}
else
{
   fatalErrord(A_ComputerName, A_ScriptName, "macro not designed for this computer")
}

;start of the actual macro... this was originally written just for BAUSTIAN12
;fatalIfNotThisPC("BAUSTIAN12")
if (A_ComputerName = "BAUSTIAN12")
{
   ProcessExist("WinSplit.exe")
   if NOT ErrorLevel
      RunProgram("WinSplit.exe")
}

;TODO check if GVIM window already exists?
;ProcessExist("gvim.exe")
;if ErrorLevel
   ;ExitApp

Run, C:\Dropbox\Programs\Vim\vim72\gvim.exe, C:\Dropbox\AHKs

;if (A_ComputerName = "BAUSTIAN12" AND ProcessExist("WinSplit.exe") )
;{
;   ForceWinFocus("GVIM ahk_class Vim", "Contains")
;   SendInput, ^!{NUMPAD5}
;}

ForceWinFocus("GVIM ahk_class Vim", "Contains")
Send, {F2 3}^w{RIGHT}{;}q{ENTER}
SleepSeconds(2)
if NOT ForceWinFocusIfExist("NERD_tree ahk_class Vim", "Contains")
   Send, {F2}^w{RIGHT}{;}q{ENTER}
