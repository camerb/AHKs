#include FcnLib.ahk

;FolderToCopy := Prompt("What folder do you want to transfer to another computer?", "folder")
;DestinationComputer := Prompt("What PC do you want to transfer it to?")
FolderToCopy=C:\Documents and Settings\Baustian\Application Data\.minecraft
DestinationComputer=PHOSPHORUS

remotePath=C:\Dropbox\AHKs\gitExempt\transferTo

FileCreateDir, %RemotePath%\%DestinationComputer%\%DateStamp%
DateStamp := CurrentTime()
DirSize := DirGetSize(FolderToCopy)
iniFile = %RemotePath%\%DestinationComputer%\%DateStamp%.ini
IniWrite, %DirSize%, %iniFile%, TransferTo-Info, DirSize
IniWrite, %FolderToCopy%, %iniFile%, TransferTo-Info, DirName
IniWrite, %A_ComputerName%, %iniFile%, TransferTo-Info, FromComputer
IniWrite, %DateStamp%, %iniFile%, TransferTo-Info, DateStamp
FileCopyDir, %FolderToCopy%, %RemotePath%\%DestinationComputer%\%DateStamp%
