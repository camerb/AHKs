#include FunctionLibrary.ahk

;IsFileEqual(1, 2)
loop 9
{
   file=temporary%A_Index%.ahk
   ;debugbool(IsFileEqual("template.ahk",file))
   if IsFileEqual("template.ahk",file)
   {
      ;debug(file)
      break
   }
}

if ForceWinFocusIfExist("(AHKs|No Name).*GVIM", "RegEx")
{
   Send, {ESC 6}
   Send, ^wl
   Send, {;}
   SendInput, split %file%{ENTER}
}
