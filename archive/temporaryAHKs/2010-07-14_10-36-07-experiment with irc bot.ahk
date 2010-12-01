#include thirdParty\winsock2.ahk
#include FcnLib.ahk
#singleinstance force
#persistent
setbatchlines -1
onexit exithandler
ws2_cleanup()
socket:=ws2_connect("irc.freenode.net:6667")
ws2_asyncselect(socket,"dataprocess")
send("NICK [GM]bot")
send("USER [GM]bot * * :#joe's resident bot, owned by skylord5816")
send("JOIN #joe")
return

dataprocess(socket,data){
	static differentnick = 0
        ;msgbox % data ;for testing
        if (InStr(data, "bot"))
           msgbox, Did that guy say my name?
           ;send("MODE #joe +ov camerb_ camerb_")
           ;send("hey, did you say my name?")
           ;TrayMsg("Did that guy say my name?")
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
		send("PONG " param2)
	else if(instr(data,"* [GM]bot :Nickname is already in use.")){
		if(differentnick = 0){
			random,rand,11111,99999
			send("NICK [GM]bot" rand)
			differentnick := 1
		}
		settimer, nick, -60000
	}
	else if(param2 == "JOIN" && regexmatch(param3,"^(list|of|authorized|users|which|will|hopefully|not|be|hardcoded|much|longer)$"))
		send("MODE #joe +ov " name " " name)
	else if(param2 == "KICK" && instr(data,"[GM]bot"))
		send("JOIN " param3)
}

send(data){
	global socket
	ws2_senddata(socket,data "`r`n")
}

exithandler:
send("PART #joe")
send("QUIT")
ws2_cleanup()
exitapp

nick:
send("NICK [GM]bot")
return

