#include FcnLib.ahk

;GUI for REFP

path=C:\My Dropbox\AHKs\REFP\
infile=%path%in1.txt
refile=%path%regex1.txt
outfile=%path%out1.txt

Gui, Add, Text,, Please enter your name:
Gui, Add, Edit, r10 vInFileContents
Gui, Add, Edit, r10 vReFileContents
Gui, Add, Edit, r10 vOut ReadOnly
Gui, Add, Button, Default, Run
Gui, Show
return

ButtonRun:
Gui, Submit
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

Gui, Show

;ExitApp
return
