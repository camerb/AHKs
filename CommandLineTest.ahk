#include FcnLib.ahk

Loop %0%
{
   Send, ^a
   Sleep, 100
   Send, %A_Index%
   Sleep, 100
   Send, {TAB}
}

;debug(param1)
;debug(param2)
