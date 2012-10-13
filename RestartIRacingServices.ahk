#include FcnLib.ahk

;restart iracing services, so that I can join another session quickly
CmdRet_RunReturn("sc stop iRacingService")
CmdRet_RunReturn("taskkill /im iRacingSim.exe /f")
CmdRet_RunReturn("net stop iRacingService")
CmdRet_RunReturn("net start iRacingService")
Run, http://members.iracing.com/membersite/member/Home.do?page=dash
