#include FcnLib.ahk

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
   ;TODO use F2 to manipulate Nerdtree, not ^w
   Send, {ESC 6}
   Send, ^wl
   Send, {;}
   SendInput, split C{;}/Dropbox/AHKs/%file%{ENTER}{F2 2}
}
