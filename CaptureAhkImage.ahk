#include FcnLib.ahk
#singleinstance force

if ( GetOS() == "WIN_7" )
{
   Send, {PrintScreen}
   Sleep, 100
   IfWinExist, ahk_class MSPaintApp
   {
      fatalErrord("Paint is already open")
   }

   Run, C:\Windows\system32\mspaint.exe
   WinWait, Untitled - Paint ahk_class MSPaintApp
   Sleep, 100
   Send, ^v
   Sleep, 100
   Click(186, 69)
   Sleep, 100
   Click(186, 69)


   KeyWait, ``, D
   Send, ^+x
   Sleep, 100
   Send, ^s
   WinWait, Save As
   description := Prompt("Provide a short description of the image (or something like 'images/appName/description')")
   ForceWinFocus("Save As")
   time:=CurrentTime()
   path=C:\DataExchange\InstantAhkImage
   description:=StringReplace(description, "/", "\")
   if RegExMatch(description, "(images)\\(.*?)\\(.*?)$", MatchVar)
   {
      path=C:\Dropbox\AHKs\images\%MatchVar2%
      description=%MatchVar3%
      time:=""
   }
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
else if ( GetOS() == "WIN_XP" )
{
   Send, {PrintScreen}
   Sleep, 100
   IfWinExist, ahk_class MSPaintApp
   {
      fatalErrord("Paint is already open")
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
   description := Prompt("Provide a short description of the image (or something like 'images/appName/description')")
   ForceWinFocus("Save As")
   time:=CurrentTime()
   path=C:\DataExchange\InstantAhkImage
   description:=StringReplace(description, "/", "\")
   if RegExMatch(description, "(images)\\(.*?)\\(.*?)$", MatchVar)
   {
      path=C:\Dropbox\AHKs\images\%MatchVar2%
      description=%MatchVar3%
      time:=""
   }
   FileCreateDir, %path%
   ForceWinFocus("Save As")
   SendInput, %path%\%time%%description%.bmp
   Sleep, 100
   ControlClick, &Save
   WinWaitClose, Save As
   Sleep, 100
   WinClose, ahk_class MSPaintApp
}
else
{
   fatalErrord("looks like this OS is unsupported", "GetOS()", GetOS(), "A_ComputerName", A_ComputerName)
}
ExitApp

ESC::ExitApp
