#include FcnLib.ahk

SetBatchLines -1
Process, Priority,, High
a := 1, b := 0, LoopCount := 10000000
st1 := A_TickCount
Loop % LoopCOunt
   If (a==b){
   }
b := 1
Loop % LoopCount
   If (a==b){
   }
end1 := A_TickCount

a := 1, b := 0
st2 := A_TickCount
Loop % LoopCount
   If (a=b){
   }
b := 1
Loop % LoopCount
   If (a=b){
   }
end2 := A_TickCount
MsgBox % "== was " (end1-st1) "`n= was " (end2-st2)



 ~esc::ExitApp