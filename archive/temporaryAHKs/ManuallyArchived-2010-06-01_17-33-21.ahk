#include FcnLib.ahk
#singleinstance force

filename=DebuggerCommands.txt

;Options:=""
Loop, read, %filename%
{
   Options=%A_LoopReadLine%|%Options%
}
   ;Options+="yo"
   ;Options+=A_LoopReadLine
;Debug(Options)

Gui, Add, ComboBox, vDebuggerCommand w600, %Options%
Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Show,, Choose the item to debug
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ExitApp

ButtonOK:
Gui, Submit  ; Save the input from the user to each control's associated variable.
;debug(DebuggerCommand)
FileAppend, `n%DebuggerCommand%, %filename%
ExitApp

;Gui, Add, ComboBox, vDebuggerCommand, Red|Green|Blue|Black|White
;Gui, Add, Button, default, OK
;Gui, Submit
;Gui, Show, Title Here

;GuiClose:
;ButtonOK:
;Gui, Submit  ; Save the input from the user to each control's associated variable.
;;MsgBox You entered "%FirstName% %LastName%".
;ExitApp

;Debug(DebuggerCommand)
;return
