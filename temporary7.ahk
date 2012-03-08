#include FcnLib.ahk

;debug("open:", IsVmRunning())

if NOT IsVmRunning()
   OpenVM()
