#include FcnLib.ahk

#IfWinActive ahk_class Notepad
$F5:: 
;Calling Excel shortcut
send {F5} 
return
#IfWinActive

;hotkey for applications that aren't excel
$F5:: 
msgbox NOOO!! 
return 



 ~esc::ExitApp