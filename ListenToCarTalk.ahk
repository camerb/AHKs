#include FcnLib.ahk

showNumber:=prompt("Which show number of CarTalk would you like to listen to?`n(e.g.: 1109)")

ForceWinFocus("foobar2000")

Loop 15
{
   PartNo:=ZeroPad(A_Index, 2)
   Send, ^u
   SendInput, http://www.publicbroadcasting.net/cartalk/.jukebox?action=playFile&title=CT%ShowNumber%%PartNo%.mp3
   Send, {ENTER}
   win=Processing Files
   WinWaitActive, %win%
   WinWaitNotActive, %win%
   ;Sleep, 1000
}

ss()
{
sleep, 5000
}
