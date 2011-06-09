#include FcnLib.ahk

timer:=StartTimer()
DoSomeExperimentalThing()
totalTime:=ElapsedTime(timer)
msgbox % totalTime



 ~esc::ExitApp