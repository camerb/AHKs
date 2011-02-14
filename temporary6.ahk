#include FcnLib.ahk

;^2::
;debug()
;return


^2::
      BlockInput, On
        Send, ^+9
        Sleep, 150
        Send, ^2
      BlockInput, Off
        Sleep, 1200
      BlockInput, On
        Send, ^+-
      BlockInput, Off
    return
