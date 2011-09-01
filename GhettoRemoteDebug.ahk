#include FcnLib.ahk

;note that this is remote debugging perl... i always seem to forget that

source=C:\Dropbox\workbench_temp_call_record.pl
dest=C:\code\EPMS\script\misc_importers\workbench_temp_call_record.pl
FileCopy, %source%, %dest%, 1

RunWait, DebugAgain.ahk

;copy from cmd prompt
ForceWinFocus("Administrator: Command Prompt")
   Sleep 100
   MouseClick, right, 100, 100
   Sleep 100
   Send, {DOWN 4}{ENTER}
   Sleep 100
   Send, {ENTER}

file=C:\Dropbox\report.txt
FileDelete, %file%
FileAppend, %Clipboard%, %file%
SleepSeconds(20)
Run, ForceReloadAll.exe
