#include FcnLib.ahk
;#persistent
;F1::
TrayTip, Title, Text, 30
sleep, 500
IfWinExist, ahk_class tooltips_class32
winactivate
sleep, 5000
;return

;TrayMsg("joe", "bobbob")
