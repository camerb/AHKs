#include FcnLib.ahk

;TODO this doesn't always seem to be enough.
;maybe we should make a RunWaitOpen() fcn so that it runs the app, then waits to see if the app opens up
;  if the app doesn't open a window, then it tries to do the run command again
Run, "C:\Program Files (x86)\Pidgin\pidgin.exe"

joinIrc("ahk")
joinIrc("ahk-social")
joinIrc("dbix-class")
startGchat("frigg")

ForceWinFocus("frigg")
Send, ^!a

ForceWinFocus("Buddy List")
WinClose
ExitApp

joinIrc(channel)
{
   ForceWinFocus("Buddy List")
   Send, ^c
   ForceWinFocus("Join a Chat")
   ;ControlSend, , {ALT DOWN}c{ALT UP}, Join a Chat
   ss()
   Click(460, 100)
   ss()
   if (channel == "dbix-class")
      Click(165, 137)
   else
      Click(165, 115)
   ss()
   SendRaw, #%channel%
   Send, {ENTER}
}

startGchat(user)
{
   ForceWinFocus("Buddy List")
   Send, ^m
   ForceWinFocus("Pidgin")
   ss()
   Send, %user%{ENTER}
}

ss()
{
   sleep 200
}
