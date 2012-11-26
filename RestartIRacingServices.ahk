#include FcnLib.ahk
#include thirdParty\notify.ahk

;restart iracing services, so that I can join another session quickly
CmdRet_RunReturn("sc stop iRacingService")
CmdRet_RunReturn("taskkill /im iRacingSim.exe /f")
CmdRet_RunReturn("net stop iRacingService")
notify("restarting service (stopped)")
SleepSeconds(10)
CmdRet_RunReturn("net start iRacingService")
notify("started iracing service (and launching webpage)")
Run, http://members.iracing.com/membersite/member/Home.do?page=dash
