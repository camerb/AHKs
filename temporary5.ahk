#include FcnLib.ahk

SleepSeconds(2)

height := A_ScreenHeight
width := A_ScreenWidth

Loop %height%
{
   y := A_Index
   Loop %width%
   {
      x := A_Index
      ;delog(x, y)
      MouseMove, x, y
      Sleep, 10
   }

}
