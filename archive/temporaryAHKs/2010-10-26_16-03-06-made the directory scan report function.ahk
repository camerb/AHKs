#include FcnLib.ahk

DirectoryScan("C:\DataExchange\*", "C:\Dropbox\dirScan-workDataEx.txt")

;Make a report file of all the files that match the given pattern in the specified directory
DirectoryScan(directoryToScan, reportFilePath)
{
   time:=CurrentTime("hyphenated")
   timer:=StartTimer()
   count=0
   Loop, %directoryToScan%, 1, 1
   {
      FileAppend, %A_LoopFileFullPath%`n, %reportFilePath%
      count++
   }
   result:=ElapsedTime(timer)
   FileAppend, Time to complete: %result%ms`n, %reportFilePath%
   FileAppend, Total items: %count%`n, %reportFilePath%
   FileAppend, Current Time: %time%`n, %reportFilePath%
}
