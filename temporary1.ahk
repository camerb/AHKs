#include FcnLib.ahk
#include thirdParty\notify.ahk

;Run, SupervisionCore.ahk
;SleepSeconds(2)
;if NOT ( prompt("proceed to copy? press y") = "y" )
   ;ExitApp

CompileAhk("SupervisionCore.ahk")
notify()
Run, SupervisionCore.exe
SleepSeconds(2)
if NOT ( prompt("proceed to copy? press y") = "y" )
   ExitApp
ProcessCloseAll("SupervisionCore.exe")

src=C:\Dropbox\AHKs\SupervisionCore.exe
dest=C:\Dropbox\AHKs\SupervisionCore1.exe
FileCopy(src, dest, "overwrite")
