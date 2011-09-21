#include FcnLib.ahk

Joy9::
Loop
{
   GetKeyState, state, %A_ThisHotkey%, P
   if state = U  ; The key has been released, so break out of the loop.
      break

   Send, {SPACE DOWN}
   Sleep, 100
   Send, {SPACE UP}
   Sleep, 10
}
return
