#include FcnLib.ahk

SetTitleMatchMode, 2

if (A_ComputerName = "PHOSPHORUS")
   ;if you already have a console open, this will end up closing that console at the end
   ;so this works for startup, but not after startup
   Send, #4
else
   Run, C:\Windows\system32\cmd.exe

CustomTitleMatchMode("RegEx")
WinWaitActive, (Administrator. Command Prompt|cmd.exe)
CustomTitleMatchMode("Default")
Sleep, 500
SendInput, cd "C:\Dropbox\Programs\irssi\"{ENTER}
SendInput, irssi.bat{ENTER}
WinWaitActive, camerb
WinClose, irssi.bat

