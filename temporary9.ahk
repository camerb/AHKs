#include FcnLib.ahk


Gui Add, Text, , Waiting for Enter or NumpadEnter ...
Gui Show, , Just Kill Me!

Loop
{
  Input, useless, V *, {Enter}{NumpadEnter}
  IfInString, ErrorLevel, EndKey:
  {
      Gui Destroy
      ExitApp
  }
}
