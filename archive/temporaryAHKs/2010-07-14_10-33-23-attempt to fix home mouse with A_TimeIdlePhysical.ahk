#include FcnLib.ahk

ESC:: Suspend

LButton::
if (A_TimeIdlePhysical > 100)
   debug(A_TimeIdlePhysical)
return

pgup::
debug(A_TimeIdlePhysical)
return

;ugh... A_TimeIdlePhysical is always 0 if you use it inside a hotkey
