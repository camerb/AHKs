#include FcnLib.ahk

Run, C:\Windows\system32\cmd.exe
Sleep, 500
Send, cd C:\code\mitsi\perl\trunk{ENTER}
Send, cpan .{ENTER}

;TODO perhaps we should hide the window, then exit the window when the taks is finished
