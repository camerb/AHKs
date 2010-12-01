#include FcnLib.ahk

RButton::
  While GetKeyState("RButton", "P")
  {
    SendInput, a
    Sleep, 1500
  }
Return

