#include FcnLib.ahk

;start babysitting the the ahk that we're about to open

SetTitleMatchMode, RegEx
filename=SyntaxError.ahk
Run, %filename%
WinWait, %filename%, Error.*The program will exit., 10
if (ERRORLEVEL) ;if it never saw the window above
   return
ControlClick, OK, %filename%
;Send, {ENTER}

;done babysitting

;TODO if it fails on reload... "The previous version will remain in effect."

