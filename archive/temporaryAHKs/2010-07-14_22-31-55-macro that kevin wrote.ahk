#include FcnLib.ahk


;This hot key will export the active file to the directory you specify.
;If the file is not recognized there will be a message box with that indicated.
;If the program does not see the overwrite warning dialog at the end of the export
;process it will warn the user that they may have selected the wrong location.
F9::

;Find the active window name and use a RegEx to get the file name from that
WinGetTitle, myVar, A
FoundPos := RegExMatch(myVar , "([A-Za-z\-]*)\.jsp",FileName)

;This is where you can add new export location based on file names.
if ( FileName = "file_1.jsp" or FileName = "file_2.jsp" ){
   FilePath = C:\MyDropbox\AHKs
}
else {
   MsgBox Do not recognize that file
   return
}

;Export command
Send {Alt}fo

WinWait, Export
ControlSetText, Edit1, File System
Sleep 300
Send {Enter}
Send {Enter}
WinWait, Export
ControlSetText, Edit2, %FilePath%, Export
;Sleep 100
ControlClick, &Finish, Export,,,,NA

;wait for the overwrite warning box
WinWait,  Question,,1
if ErrorLevel{
   MsgBox The Overwrite Warning dialog box did not appear. `n You may have tried to save to the wrong folder.
   return
}
Sleep 300
ControlClick, &Yes, Question,,,,NA
return
