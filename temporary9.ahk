#include FcnLib.ahk

;Capslock::LCtrl
Capslock::
;LCtrl
debug(A_ThisHotkey)
return

$f::
debug(A_ThisHotkey)
if(GetKeyState("Capslock", "P"))
   Send, {Left}
return

