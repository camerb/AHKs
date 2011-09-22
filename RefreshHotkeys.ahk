;Reload WorksInProgress.ahk (generally if something went wrong in the normal hotkey--single instances for hotkeys)
^+!#r:: CloseAllAhks()
;Run, ForceReloadAll.exe

;Standard reload hotkey
AppsKey & r::

;save if gvim has it open (but reload no matter what)
if ForceWinFocusIfExist("(.txt.*ahk|AHKs|ahk).*GVIM", "RegEx")
{
   Send, {ESC}{ESC}
   Send, {;}
   Send, wa{ENTER}
}
DetectHiddenWindows, On
IfWinExist, fireflyButtons.ahk
{
   BlockInput, MouseMoveOff
   AhkClose("fireflyButtons.ahk")
   RunAhk("fireflyButtons.ahk")
}
DetectHiddenWindows, Off
Reload
return ;end of Appskey r hotkey
