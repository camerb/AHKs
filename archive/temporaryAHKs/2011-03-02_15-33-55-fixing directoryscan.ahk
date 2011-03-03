#include FcnLib.ahk

directoryToScan=C:\
time:=CurrentTime("hyphenated")
timer:=StartTimer()
count=0
debug(directoryToScan)
directoryToScan := EnsureEndsWith(directoryToScan, "\")
debug(directoryToScan)
Loop, %directoryToScan%*, 1, 1
{
   debug(A_LoopFileFullPath)
   ;FileAppendLine(A_LoopFileFullPath, reportFilePath)
   count++
   if count >5
   break
}
result:=ElapsedTime(timer)
debug("items", count)
