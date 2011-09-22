#include FcnLib.ahk

Loop
{
   ;ClickIfImageSearch("images/firefly/expandJob.bmp")
   filename=images/firefly/expandJob.bmp

   WinGetPos, no, no, winWidth, winHeight, A
   ImageSearch, xvar, yvar, 0, 0, 150, winHeight, %filename%

   ;TODO but wasn't there something that would allow me to search from bottom to top?
   ;WinGetPos, no, no, winWidth, winHeight, A
   ;ystart:=winHeight
   ;yfinish:=0
   ;ImageSearch, xvar, yvar, 0, ystart, winWidth, yfinish, %filename%

   if NOT ErrorLevel
      Click(xvar, yvar, clickOptions)
}
