#include thirdParty\winsock2.ahk
#include FcnLib.ahk
#singleinstance force
#persistent
setbatchlines -1
onexit exithandler
ws2_cleanup()
socket:=ws2_connect("irc.freenode.net:6667")
ws2_asyncselect(socket,"dataprocess")
send("NICK " . nick())
send("USER " . nick() . " * * :the camerb irc client, made by camerb")
send("JOIN " . channel())
;debug("hi")
;TODO here's where we should do periodic checks, like if we should set the status to "away"
return

;TODO identify
;TODO ipc gui
;TODO multi-channel
;TODO config files

dataprocess(socket,data){
	static differentnick = 0
        ;msgbox % data ;for testing
        addtotrace(data)

        ;if (InStr(data, "bot"))
           ;msgbox, Did that guy say my name?

	stringtrimright,data,data,2
	if(instr(data,"`r`n")){
		stringreplace,data,data,`r`n`r`n,`r`n
		loop,%data%,`n,`r
			dataprocess(socket,a_loopfield)
		return
	}
	stringsplit,param,data,%a_space%
	name:=substr(data,2,instr(data,"!")-2)
	if(param1 == "PING")
        {
           send("PONG " param2)
           checkIfAfk()
        }
	else if(instr(data,"* " . nick() . " :Nickname is already in use.")){
		if(differentnick = 0){
			random,rand,11111,99999
			send("NICK " . nick() . rand)
			differentnick := 1
		}
		settimer, nick, -60000
	}
	else if(param2 == "JOIN" && regexmatch(param3,"^(list|of|authorized|users|which|will|hopefully|not|be|hardcoded|much|longer)$"))
		send("MODE #joe +ov " name " " name)
	else if(param2 == "KICK" && instr(data,nick()))
		send("JOIN " param3)
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

nick()
{
   return "camerb_girc"
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
   if (A_TimeIdlePhysical > 1000 * 60 * 10)
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
