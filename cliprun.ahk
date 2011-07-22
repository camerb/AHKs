#include FcnLib.ahk

  Run Abbreviations.ahk
  SetTitleMatchMode, 2
  WinGet, pid, PID, Abbreviations.ahk
  msgbox % "the pid is" . pid
  Process, Close, %pid%



 ~esc::ExitApp