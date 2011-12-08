#include FcnLib.ahk

Loop
{
   ;ClickIfImageSearch("images/nfsw/NextButton.bmp")
   Send, j
   Send, [
   Sleep, 100
}

;Joy4::
;Send, {SPACE DOWN}
;Sleep, 100
;Send, {SPACE UP}
;return

Joy6::
Send, {SPACE DOWN}
Sleep, 160
Send, {SPACE UP}
return

Joy9::
Send, {SPACE DOWN}
Sleep, 320
Send, {SPACE UP}
Reload
return

;Joy1::
;Send, {NUMPAD4}
;return
;Joy2::
;Send, {NUMPAD6}
;return
;Joy3::
;Send, {NUMPAD8}
;return
;Joy5::
;Send, {NUMPAD2}
;return

;Joy4:
;Joy6:
;Joy8:
;if (A_ThisHotkey = "Joy4")
   ;sleepTime:=80
;if (A_ThisHotkey = "Joy6")
   ;sleepTime:=150
;if (A_ThisHotkey = "Joy8")
   ;sleepTime:=220

;Loop
;{
   ;GetKeyState, state, %A_ThisHotkey%, P
   ;if state = U  ; The key has been released, so break out of the loop.
      ;break

   ;Send, {SPACE DOWN}
   ;Sleep, %sleepTime%
   ;Send, {SPACE UP}
   ;Sleep, 10
;}
;return

;Joy4: msg("Pass High")
;Joy6: msg("Stay in line and work together")
;Joy8: msg("Thank you")
