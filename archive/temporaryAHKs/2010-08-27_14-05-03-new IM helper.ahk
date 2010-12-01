#include FcnLib.ahk

person := Prompt("Who would you like to IM?")

if (InStr(person, "mel"))
   person=Melinda
if (InStr(person, "nat"))
   person=Nathan Dyck

SendInput, ^m
WinWaitActive, Pidgin
SendInput, %person%
SendInput, {DOWN}{ENTER 2}
