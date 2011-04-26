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

desktopSidebarNeedsRelocating()
{
   debug("checking desktop sidebar position")
   WinGetPos, xPos, no, no, winHeight, ahk_class SideBarWndv10
   ;debug(xpos, winheight)
   if (xPos < 2500)
      return true
   return false
}

moveDesktopSidebar()
{
   debug("moving desktop sidebar")
   ;DSTBDTT ;WinActivate, ahk_class SideBarWndv10
   ForceWinFocus("ahk_class SideBarWndv10")
   ;TODO figure out a way to ensure that the sidebar is actually responding to WinActivate
   Sleep, 100
   SendInput, {AppsKey}
   ;MouseMove, 20, winHeight - 20
   ;Click(20, winHeight - 20, "Right")
   Sleep, 100
   Send, {DOWN 2}{ENTER}

   WinWaitActive, Options, , 10
   if NOT errorLevel
   {
      ;messWithOptionsForDesktopSidebar()
      WinWaitActive, Options
      ;ForceWinFocus("Options")
      Click(95,  41)
      Sleep, 100
      Click(390,  249)
      Sleep, 100
      Click(401,  279)
      Sleep, 100
      Click(239,  553)
      Sleep, 100
      ;debug()
   }
}

;TODO... make this more generalized (for google chrome restore bar)
IsYellowPixel(xCoord, yCoord)
{
   hexColor := PixelGetColor(xCoord, yCoord, "RGB")
   return !! RegExMatch(hexColor, "0x(F).(F|E).(B|A|9).")
}
