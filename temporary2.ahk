#include FcnLib.ahk

ProcessClose("RLMArena.exe")
RunProgram("C:\Program Files\RLM Arena 4.2\RLMArena.exe")
WinWaitActive, , Enter your username and password for your RaceLM league.
ss()
Send, {TAB 3}{ENTER}
ss()
WinWaitActive, , Select League
ss()
Send, {TAB 2}{DOWN}

ss()
{
sleep, 1000
}
