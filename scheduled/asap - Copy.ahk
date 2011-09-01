#include FcnLib.ahk

filepath:="C:\Dropbox\dirScan-homeDataEx.txt"
time:=CurrentTime("hyphenated")
timer:=StartTimer()
count=
Loop, C:\DataExchange\*, 1, 1
{
   FileAppend, %A_LoopFileFullPath%`n, %filepath%
   count++
}
result:=ElapsedTime(timer)
FileAppend, Time to complete: %result%`n, %filepath%
FileAppend, Total items: %count%`n, %filepath%
FileAppend, Current Time: %time%`n, %filepath%
