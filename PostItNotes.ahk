#include FcnLib.ahk

WinGetActiveTitle, titleofwin

if RegExMatch(titleofwin, "AHKs.*GVIM")
{
   postit:="^  Control`n+  Shift`n!  Alt`n#  Win"
}

if postit
   Msgbox % postit
