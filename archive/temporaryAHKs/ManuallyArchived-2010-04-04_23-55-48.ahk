#include FcnLib.ahk

while true
{
   Process, Exist, AutoHotKey.exe
   if NOT ERRORLEVEL
      break
   ;debug("about to close an ahk")
   ;Sleep, 1000
   Process, Close, AutoHotKey.exe
}
;debug("about to run main ahk file again")
Run, AutoHotKey.ahk
