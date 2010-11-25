SetTitleMatchMode, RegEx
#SingleInstance force

#Persistent
SetTimer, CloseWarnings, 2000
return

CloseWarnings:
SetTitleMatchMode, 2
IfWinActive, Notepad
   debug("Notepad is selected")
return

#IfWinActive titled.*
`:: debug("You pressed a hotkey for notepad")
#IfWinActive

Debug(text="Hello World, from AHK!")
{
   MsgBox, , , %text%, 1
}
