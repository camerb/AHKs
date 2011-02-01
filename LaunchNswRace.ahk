#include FcnLib.ahk

Process, Close, dsidebar.exe
RunProgram("C:\Program Files\SMS_Lobby\SMSLobby.exe")
SoundSet, 30

WinWaitActive, , NR2003
Sleep, 100
MouseClick, left,  502,  79
Send, race

ClickIfImageSearch("images/smsLobby/NascarSimWorld.bmp")
Click(935, 110)
