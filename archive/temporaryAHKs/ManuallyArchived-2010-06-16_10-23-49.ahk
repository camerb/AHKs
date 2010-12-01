#include FcnLib.ahk
#singleinstance force

x := "a|b|c|d|e|f|g"
num :=1
stringsplit, xx,x, | ; this will put a b c on x1 x2 x3 respectively

F11::
x :=  xx%num%
SendInput t/feat %x% %num% {enter}
++num
if num > 7
   num := 1
return

