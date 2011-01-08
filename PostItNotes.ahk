#include FcnLib.ahk

WinGetActiveTitle, titleofwin

if RegExMatch(titleofwin, "AHKs.*GVIM")
{
   postit:="^  Control`n+  Shift`n!  Alt`n#  Win"
}
if RegExMatch(titleofwin, "Irssi")
{
   postit:="skylordikins: stfu skylordikins <reply>$who: shut up"
}

if postit
   Msgbox % postit
