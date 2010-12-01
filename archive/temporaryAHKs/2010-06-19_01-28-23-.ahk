#include FcnLib.ahk
#singleinstance force

if (A_ComputerName == "PHOSPHORUS")
{
   Send, {PrintScreen}
   Sleep, 100
   IfWinExist, ahk_class MSPaintApp
   {
      WinActivate
      debug("Paint is already open")
      return
   }

   Run, C:\Windows\system32\mspaint.exe
   WinWait, Untitled - Paint ahk_class MSPaintApp
   Sleep, 100
   Send, ^v
   Sleep, 100
   Click(186, 69)
   Sleep, 100
   Click(186, 69)


   ;KeyWait, AppsKey, U
   KeyWait, ``, D
   Send, ^s
   WinWait, Save As
   InputBox, description, Image Description, Provide a short description of the image
   time:=CurrentTime()
   path=C:\DataExchange\InstantAhkImage
   FileCreateDir, %path%
   SendInput, %path%\%time%%description%.bmp
   Sleep, 100
   MouseClick, left,  221,  449
   Sleep, 100
   MouseClick, left,  207,  514
   Sleep, 100
   MouseClick, left,  672,  498
   Sleep, 100
   WinClose, ahk_class MSPaintApp
}
if (A_ComputerName == "BAUSTIAN-09PC")
{
   Send, {PrintScreen}
   Sleep, 100
   IfWinExist, ahk_class MSPaintApp
   {
      WinActivate
      debug("Paint is already open")
      return
   }

   Run, C:\Windows\system32\mspaint.exe
   WinWait, untitled - Paint ahk_class MSPaintApp
   Sleep, 100
   Send, ^v
   Click(15, 70, "Control")
   Click(40, 70, "Control")




   KeyWait, ``, D

   Send, ^x^e1{TAB}1{ENTER}^v

   Send, ^s
   WinWait, Save As
   InputBox, description, Image Description, Provide a short description of the image
   time:=CurrentTime()
   path=C:\DataExchange\InstantAhkImage
   FileCreateDir, %path%
   ForceWinFocus("Save As")
   SendInput, %path%\%time%%description%.bmp
   Sleep, 100
   Click(506, 370, "Control")
   Sleep, 100
   WinClose, ahk_class MSPaintApp
}
