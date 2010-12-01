;Automate cpan update (press enter whenever it asks a question)
;TODO beter solution is to take a screenshot of the window, and compare it to one from a minute ago... if it hasn't changed, then hit enter (prod it along)

#include FcnLib.ahk

cpanWindow=cpan ahk_class ConsoleWindowClass

while true
{
   SetTitleMatchMode, RegEx
   IfWinNotExist, cpan ahk_class ConsoleWindowClass
      break

   if (IfImageSearch("images\cmd\OptionalCpanModule.bmp", cpanWindow))
   {
      ;WinGet ActiveWindow
      ForceWinFocus(cpanWindow)
      Send, {Enter}
      Sleep, 200
      ;ForceWinFocus ... prev window
   }

   Sleep, 50
}


;If you see the image
IfImageSearch(filename, windowTitle="")
{
   ;search inactive windows, too
   CoordMode, Pixel, Screen

   if NOT FileExist(filename)
   {
      debug(%filename% does not exist)
      return
   }

   WinGetPos, xpos, ypos, winWidth, winHeight, %windowTitle%
   ImageSearch, xvar, yvar, xpos, ypos, winWidth+xpos, winHeight+ypos, *%variation% %filename%

   ;reset Coordmode
   CoordMode, Pixel, Relative

   return NOT ErrorLevel
}

