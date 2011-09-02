#include FcnLib.ahk
#include thirdparty/notify.ahk

;notify("started")

;Joy1: notify(A_ThisHotkey)
;Joy2: notify(A_ThisHotkey)
Joy3:: msg("Pass Low")
Joy4:: msg("Pass High")
Joy5:: msg("Pitting this time by")
;Joy6;: msg("Stay in line and work together")
Joy7:: msg("Sorry")
Joy8:: msg("Thank you")

Joy6::
key := cycle("1|2|3|4|5|6|7|8|9")
keystroke={F%key%}
Send, %keystroke%
return

;Joy6::
;Loop
;{
   ;GetKeyState, state, %A_ThisHotkey%, P
   ;if state = U  ; The key has been released, so break out of the loop.
      ;break

   ;;KEY:=Cycle("ESC|ENTER")
   ;;Send, {%KEY%}
   ;ControlSend, , {- down}
   ;Sleep, 100
;}
;ControlSend, , {- up}
;return

Joy9::
Loop
{
   GetKeyState, state, %A_ThisHotkey%, P
   if state = U  ; The key has been released, so break out of the loop.
      break

   ;KEY:=Cycle("ESC|ENTER")
   ;Send, {%KEY%}
   Send, {ESC}
   Sleep, 10
   Send, {ENTER}
   Sleep, 100
}
return

`::ExitApp

msg(message)
{
   Send, t
   Sleep, 100
   Send, %message%
   Sleep, 100
   Send, {ENTER}
}
