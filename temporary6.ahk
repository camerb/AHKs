#include FcnLib.ahk

;need to:
;restart thunderbird nightly

;win count Thunderbird
;if count > 1, then exitapp

;winclose thunderbird
;IfWinExist, Mozilla Thunderbird
if ForceWinFocusIfExist("Mozilla Thunderbird", "Contains")
   WinClose

SleepMinutes(2)
RunProgram("thunderbird.exe")
