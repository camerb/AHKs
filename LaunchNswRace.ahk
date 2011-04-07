#include FcnLib.ahk

RunWait, ChangeLogitechWheelMode.ahk
RunWait, LaunchTeamspeak.ahk

Process, Close, FindAndRunRobot.exe
Process, Close, dsidebar.exe
SoundSet, 30
LaunchRaceFromSmsLobby()
ExitApp

LaunchRaceFromSmsLobby()
{
   RunProgram("C:\Program Files\SMS_Lobby\SMSLobby.exe")

   WinWaitActive, , NR2003
   Sleep, 100
   WaitForImageSearch("images/smsLobby/NascarSimWorld.bmp")
   ClickIfImageSearch("images/smsLobby/NascarSimWorld.bmp")
   Sleep, 100
   MouseClick, left,  502,  79
   Send, race
   Sleep, 100

   Click(935, 110)
}
