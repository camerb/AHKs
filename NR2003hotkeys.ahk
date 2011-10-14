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
keystroke := cycle("{F1}|{F2}{SPACE}|{SPACE}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}")
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
