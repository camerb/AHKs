#include *i thirdParty\winsock2.ahk
#include *i winsock2.ahk
;#include *i FcnLib.ahk
#singleinstance force
#persistent
setbatchlines -1
onexit exithandler

;make connection
ws2_cleanup()
socket:=ws2_connect("irc.freenode.net:6667")
ws2_asyncselect(socket,"dataprocess")

;choose nick
changenick(nick())
send("USER " . nick() . " * * :the camerb irc client, made by camerb")
send("JOIN " . channel())

Gui, +LastFound -Caption +ToolWindow
Gui, Add, Edit, r10 w500 vOut ReadOnly
Gui, Add, Edit, w500 vInputText
Gui, Add, Button, Default, Run
Gui, Show

;here's where we should do periodic checks, like if we should set the status to "away"
SetTimer, checkEverySecond, 1000
SetTimer, checkEveryTenSeconds, % 1000 * 10
SetTimer, checkEveryMinute, % 1000 * 60
return

ButtonRun:
Gui, Submit, NoHide
msg:="PRIVMSG " . channel() . " " . InputText
;debug(msg)
send(msg)
appendToScrollback(nick() . " " . InputText)
;GuiControl, Text, Edit1, %chatScrollback%
GuiControl, Text, Edit2,
return

;TODO identify
;TODO ipc gui
;TODO multi-channel
;TODO config files

;TODO ip lookup
;TODO nick lookup
;TODO window to look at recent pastebin
;TODO button to run recent pastebin

dataprocess(socket,data){
   static differentnick = 0
   ;msgbox % data ;for testing
   appendToScrollback(data)
   ;addtotrace(data)

   ;if (InStr(data, "bot"))
      ;msgbox, Did that guy say my name?

   ;parsing
   stringtrimright,data,data,2
   if(instr(data,"`r`n"))
   {
      stringreplace,data,data,`r`n`r`n,`r`n
      loop,%data%,`n,`r
         dataprocess(socket,a_loopfield)
      return
   }

   ;parsing
   stringsplit,param,data,%a_space%
   name:=substr(data,2,instr(data,"!")-2)

   ;respond to a ping, let them know we are here
   if(param1 == "PING")
   {
      send("PONG " param2)
      ;checkIfAfk()
   }
   ;that nick is taken, let's use a different one
   else if(instr(data,"* " . nick() . " :Nickname is already in use."))
   {
      if(differentnick = 0)
      {
         random,rand,11111,99999
         changenick(nick() . rand)
         differentnick := 1
      }
      settimer, nick, -60000
   }
   ;this seems to be for re-joining after getting kicked
   else if(param2 == "KICK" && instr(data,nick()))
      send("JOIN " param3)
   ;this is for a bot similar to ChanServ (not needed for an irc client)
   ;else if(param2 == "JOIN" && regexmatch(param3,"^(list|of|authorized|users)$"))
      ;send("MODE #joe +ov " name " " name)
}

appendToScrollback(textToAppend)
{
   global chatScrollback
   chatScrollback .= "`n" . textToAppend
   GuiControl, Text, Edit1, %chatScrollback%
   PostMessage, 0xB1, -2, -1, Edit1, A
   PostMessage 0xB7, , , Edit1, A
}

send(data){
   global socket
   ws2_senddata(socket,data "`r`n")
}

exithandler:
send("PART " . channel())
send("QUIT")
ws2_cleanup()
exitapp

nick:
changeNick(nick())
return

checkEverySecond:
return

checkEveryTenSeconds:
;debug()
checkIfAfk()
return

checkEveryMinute:
return

nick()
{
   return "cam_irc"
}

awaynick()
{
   return nick() . "^afk"
}

channel()
{
   return "##conversation"
}

checkIfAfk()
{
   if (A_TimeIdlePhysical > 1000 * 60 * 8)
      changeNick(awaynick())
   else
      changeNick(nick())
}

changeNick(newNick)
{
   global currentNick
   if (newNick != currentNick)
   {
      cmd=NICK %newNick%
      send(cmd)
      currentNick := newNick
   }
}
