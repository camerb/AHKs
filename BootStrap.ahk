#include FcnLib.ahk

Run, Startup%A_ComputerName%.ahk

RunAhk("StartIdleAhks.ahk")

;apps that should run on all my computers
Run, C:\My Dropbox\Programs\CLCL\CLCL.exe
;Dropbox
;Openoffice launcher
;Find and Run Robot
;Desktop Sidebar (ensure only one instance)
if NOT IsVM()
   RunProgram("C:\Program Files\Desktop Sidebar\dsidebar.exe")
