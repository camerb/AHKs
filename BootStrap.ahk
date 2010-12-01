#include FcnLib.ahk

Run, AutoHotkey.ahk
Run, Startup%A_ComputerName%.ahk

RunAhk("RemoteWidget.ahk")

;apps that should run on all my computers
Run, C:\My Dropbox\Programs\CLCL\CLCL.exe
;Dropbox
;Openoffice
;Find and Run Robot
;Desktop Sidebar (ensure only one instance)
