#include FcnLib.ahk

Loop
{
   ;addtotrace(A_TimeIdlePhysical)
   xpos:=Random( 92,500)
   ypos:=Random(194,500)
   PixelGetColor, color, xpos, ypos

   ;if yellow!
   if RegExMatch(color, "0x[012].[FE].F[FE]")
   {
      if (A_TimeIdlePhysical > 200)
         Click(xpos, ypos, "Mouse")
   }
}
a::Pause

;Loop
;{
;ClickMouseIfColor("0x02F6FF")
;}


;If you see the image, click it
ClickIfPixelSearch(colorBGR, clickOptions="left Mouse")
{
   WinGetPos, no, no, winWidth, winHeight, A
   ;PixelSearch, xvar, yvar, 0, 0, winWidth, winHeight, %colorBGR%
   PixelSearch, xvar, yvar, 0, 187, winWidth, winHeight, %colorBGR%

   if NOT ErrorLevel
      Click(xvar, yvar, clickOptions)

   return NOT ErrorLevel
}

ClickMouseIfColor(colorBGR)
{
   ;WinGetTitle, title, A
   ;WinGetPos, foo, bar, winWidth, winHeight, A
   ;xpos:=Random(0,winWidth)
   ;ypos:=Random(0,winHeight)
   xpos:=Random(161,500)
   ypos:=Random(194,500)
   ;MouseGetPos, xpos, ypos
   ;xpos++
   ;ypos++
   PixelGetColor, color, xpos, ypos
   ;addtotrace(xpos, ypos, winWidth, winHeight, color, title)

   ;if yellow!
   if RegExMatch(color, "0x[012].[FE].F[FE]")
   {
      Click(xpos, ypos, "Mouse")
      ;addtotrace("purple line")
      ;addtotrace(xpos, ypos, winWidth, winHeight, color, title)
   }
}

;ClickMouseIfColor(colorBGR)
;{
   ;;WinGetPos, no, no, winWidth, winHeight
   ;;xpos:=Random(0,winWidth)
   ;;ypos:=Random(0,winHeight)
   ;MouseGetPos, xpos, ypos

   ;PixelGetColor, color, xpos, ypos
   ;addtotrace(color)

   ;;if yellow!
   ;if RegExMatch(color, "0x[012].[FE].F[FE]")
   ;{
      ;Click
      ;addtotrace("purple line")
   ;}
;}

ESC::ExitApp
