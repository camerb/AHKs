#include FcnLib.ahk

;GUI for REFP

path=C:\Dropbox\AHKs\REFP\
infile=%path%in1.txt
refile=%path%regex1.txt
outfile=%path%out1.txt

Gui, Add, Text,, Incoming:
Gui, Add, Edit, r10 w500 vInFileContents
Gui, Add, Text,, RegEx file:
Gui, Add, Edit, r10 w500 vReFileContents
Gui, Add, Text,, Output:
Gui, Add, Edit, r10 w500 vOut ReadOnly
Gui, Add, Button, Default, Run
Gui, Show
return

ButtonRun:
Gui, Submit, NoHide
FileDelete, %infile%
FileDelete, %refile%
FileDelete, %outfile%
FileAppend, %inFileContents%, %infile%
FileAppend, %reFileContents%, %refile%
REFP()
;RunWait, RegExFileProcessor.ahk
outFileContents:=FileRead(outfile)
;debug(inFileContents, reFileContents, outFileContents)
GuiControl, Text, Edit3, %outFileContents%

;Gui, Show

;ExitApp
return
