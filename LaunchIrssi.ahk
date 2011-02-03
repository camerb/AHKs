#include FcnLib.ahk

SetTitleMatchMode, 2

if (A_ComputerName = "PHOSPHORUS")
   Send, #4
else
   Run, C:\Windows\system32\cmd.exe

CustomTitleMatchMode("RegEx")
WinWaitActive, (Administrator. Command Prompt|cmd.exe)
CustomTitleMatchMode("Default")
Sleep, 500
SendInput, cd "C:\My Dropbox\Programs\irssi\"{ENTER}
SendInput, irssi.bat{ENTER}
Sleep, 500
WinClose, irssi.bat

