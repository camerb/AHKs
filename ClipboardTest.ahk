#include FcnLib.ahk

;making a script for testing clipboard functions

path=C:\Dropbox\AHKs\gitExempt\
infile=%path%ClipboardTest.txt

Gui, Add, Text,, Edit:
Gui, Add, Edit, r10 w500 vInFileContents
Gui, Add, Button, , &Save to File
Gui, Add, Button, , &Load from File
Gui, Add, Button, , &Exit
Gui, Show,, AHK Clipboard Test
return

ButtonSaveToFile:
Gui, Submit, NoHide
FileCreate(inFileContents, infile)
return

ButtonLoadFromFile:
inFileContents:=FileRead(infile)
GuiControl, Text, Edit1, %inFileContents%
return

ButtonExit:
GUIClose:
ExitApp
return
