#include FcnLib.ahk


Gui Add, Text, , Press Enter to destroy this GUI ...
Gui Show, , Press Enter
KeyWait, NumpadEnter, D
      ExitApp

NumpadEnter & NumpadDel::
NumpadEnter & NumpadDot::
   Run notepad
Return
