#include FcnLib.ahk

debug("checking if we need to restore chrome tabs")
if ( ForceWinFocusIfExist("New Tab - Google Chrome")
   AND IsYellowPixel(686, 87)
   AND IsYellowPixel(686, 110)
   AND IsYellowPixel(1649, 87)
   AND IsYellowPixel(1649, 110) )
{
   Click(1700, 100, "Control")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;TODO... make this more generalized (for google chrome restore bar)
IsYellowPixel(xCoord, yCoord)
{
   hexColor := PixelGetColor(xCoord, yCoord, "RGB")
   return !! RegExMatch(hexColor, "0x(F).(F|E).(B|A|9).")
}
