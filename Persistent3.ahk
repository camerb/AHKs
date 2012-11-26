#include FcnLib.ahk
#NoTrayIcon

#Persistent
SetTimer, Persist, 500
ScriptCheckin("Started")
return

Persist:

;accept chanserv invites automatically (what's the harm?)
if ForceWinFocusIfExist("Pidgin ahk_class gdkWindowToplevel")
{
   if SimpleImageSearch("images/pidgin/chanservInvitation.bmp")
      Send, !a
}

ScriptCheckin("Working")
;end of Persist subroutine
return

;fcns (for this file only) will go here
