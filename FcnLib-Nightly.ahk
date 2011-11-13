#include FcnLib.ahk

;Function lib for things that are too ghetto to happen during the day

RuniMacro(script="URL GOTO=nascar.com")
{
   RunProgram("Firefox")
   ForceWinFocus("Firefox")
   while NOT SimpleImageSearch("images/imacros/imacrosText.bmp")
   {
      ClickIfImageSearch("images/imacros/imacrosIcon.bmp")
      Sleep, 500
   }

   Click(89, 680)
   Click(89, 760)

   file=C:\Dropbox\AHKs\gitExempt\iMacros\ahkScripted.iim
   FileCreate(script, file)

   ForceWinFocus("Select file to load")
   Sleep, 200
   Send, %file%{ENTER}

   Sleep, 200
   Click(46, 673)
   Sleep, 200
   Click(97, 709)
}
