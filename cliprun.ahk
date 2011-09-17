#include FcnLib.ahk

$NumpadIns::
send {Shift down}
keywait NumpadIns
send {Shift up}
return



 ~esc::ExitApp