;Reload WorksInProgress.ahk (generally if something went wrong in the normal hotkey--single instances for hotkeys)
^+!#r:: Run, ForceReloadAll.exe

;Standard reload hotkey
AppsKey & r::

;save if gvim has it open (but reload no matter what)
if ForceWinFocusIfExist("(.txt.*ahk|AHKs).*GVIM", "RegEx")
{
   Send, {ESC}{ESC}
   Send, {;}
   Send, wa{ENTER}
}
Reload
return ;end of Appskey r hotkey
