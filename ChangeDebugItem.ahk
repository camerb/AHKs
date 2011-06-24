#include FcnLib.ahk
#singleinstance force

filename=DebuggerCommands.txt

Loop, read, %filename%
{
   if A_LoopReadLine
      Options=%A_LoopReadLine%|%Options%
}

Gui, Add, ComboBox, vDebuggerCommand w600, %Options%
Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Show,, Choose the item to debug
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ExitApp

ButtonOK:
Gui, Submit  ; Save the input to each control's associated variable.
FileAppend, `n%DebuggerCommand%, %filename%
ExitApp

