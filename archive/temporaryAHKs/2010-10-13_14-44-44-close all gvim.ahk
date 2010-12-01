#include FcnLib.ahk

;Close All GVIM windows, but leave it open

ForceWinFocus("GVIM", "Contains")
Send, ^wl
Send, {ESC 6}

while true
{
   if ForceWinFocusIfExist("NERD_tree", "Contains")
      ExitApp
   Send, {;}q{ENTER}
   Sleep, 100
}
