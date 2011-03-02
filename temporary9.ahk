#include FcnLib.ahk

Loop
{
   MouseGetPos, x, y

   if (xPrev > x)
      Send, {a up}{d down}
      ;AddToTrace("left")
   else if (xPrev < x)
      Send, {d up}{a down}
      ;AddToTrace("right")

   xPrev:=x
   yPrev:=y
}
