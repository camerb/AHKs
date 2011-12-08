#include FcnLib.ahk

;exit if this computer shouldn't run this macro
if (A_ComputerName = "BAUSTIAN-09PC")
{
}
else if (A_ComputerName = "T-800")
{
}
else
{
   fatalErrord(A_ComputerName, A_ScriptName, "macro not designed for this computer")
}

;start of the actual macro... this was originally written just for baustian-09pc
;fatalIfNotThisPC("BAUSTIAN-09PC")
if (A_ComputerName = "BAUSTIAN-09PC")
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
;debug(A_WorkingDir)

if (A_ComputerName = "BAUSTIAN-09PC")
{
   ForceWinFocus("GVIM", "Contains")
   SendInput, ^!{NUMPAD5}
}

Send, {F2}^w{RIGHT}{;}q{ENTER}
