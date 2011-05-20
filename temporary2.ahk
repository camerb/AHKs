#include FcnLib.ahk
#include thirdparty/notify.ahk


SetTitleMatchMode, Slow
Loop
{
   WinGetText, Var, ahk_class Notepad
   If RegExMatch(Var,"m)frogs (\d{1,2,3})", match)
   {
      notify("yes")
      if match1 between 0 and 500
      {
                        gui, 1:
                        Gui, 1: -Caption +ToolWindow +0x00FF00 +LastFound
                        Gui, 1: Show, x200 y200 w200 h200, Gui1
         if match1 between 0 and 100
            Gui, 1:Color, red
         if match1 between 101 and 500
            Gui, 1:Color, green
         Break
         return
      }
   }
   else
      notify("no")
   sleepseconds(1)
   ;exitapp
}


;loop
	;{
		;SetTitleMatchMode, Slow
		;WinGetText, Var, ahk_class Notepad
		;RegExMatch(Var,"iS)frogs (?:100|\d\d|\d)")      ;find frogs 0 to 100
                ;If RegExMatch(Var,"iS)frogs ?(?:100|\d\d|\d)")  ;find frogs 0 to 100
		;{
			;gui, 1:
			;Gui, 1: -Caption +ToolWindow +0x00FF00 +LastFound
			;Gui, 1: Show, x200 y200 w200 h200, Gui1
			;Gui, 1:Color, red
			;Break
			;return
		;}
	;}
