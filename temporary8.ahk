#include FcnLib.ahk

;make compiling AHKs better - SuccessfullyCompiles() and CompileAhk()

Check("InfiniteLoop.ahk")
Check("CompileErrors.ahk")

Check(file)
{
CompileAhk(file)
;if NOT SuccessfullyCompiles(file)
   ;addtotrace("DID NOT COMPILE: " . file)
;else
   ;addtotrace("compiles fine:   " . file)
}
