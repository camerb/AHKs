#include FcnLib.ahk

CheckForRestoreBar(786, 87,  786, 110, 1649, 87,  1649, 110, 686, 110)
CheckForRestoreBar(786, 110, 786, 133, 1649, 110, 1649, 133, 686, 110)

CheckForRestoreBar(x1, y1, x2, y2, x3, y3, x4, y4, clickX, clickY)
{
   ;ForceWinFocusIfExist("New Tab - Google Chrome")
   ;mmd(x1, y1)
   ;mmd(x2, y2)
   ;mmd(x3, y3)
   ;mmd(x4, y4)
   ;mmd(clickX, Clicky)
   ;exitApp

   if ( ForceWinFocusIfExist("New Tab - Google Chrome")
      AND IsYellowPixel(x1, y1)
      AND IsYellowPixel(x2, y2)
      AND IsYellowPixel(x3, y3)
      AND IsYellowPixel(x4, y4) )
   {
      debug()
      Click(clickX, clickY, "Control")
   }
}

IsYellowPixel(xCoord, yCoord)
{
   hexColor := PixelGetColor(xCoord, yCoord, "RGB")
   return !! RegExMatch(hexColor, "0x(F).(F|E).(B|A|9).")
}

mmd(x, y)
{
sleepseconds(2)
mousemove, %x%, %y%
}
