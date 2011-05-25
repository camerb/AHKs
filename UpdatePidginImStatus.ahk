#include FcnLib.ahk

RunProgram("C:\Program Files (x86)\Pidgin\pidgin.exe")
while NOT ForceWinFocusIfExist("Buddy List ahk_class gdkWindowToplevel")
{
   RunProgram("C:\Program Files (x86)\Pidgin\pidgin.exe")
   Sleep, 100
   count++
   if (count > 1000)
      fatalErrord("silent log", "the pidgin window never activated", A_ScriptName, A_LineNumber)
}

ForceWinFocus("Buddy List ahk_class gdkWindowToplevel")
WinGetPos, no, no, width, height
Click(width/2, height-20, "Click")

Send, ^a
Sleep, 100

Send, {DEL}
Sleep, 100

FileRead, statusText, C:\My Dropbox\Android\sd\imStatus.txt
statusText:=RegExReplace(statusText, "(`r|`n)", " ")
statusText:=RegExReplace(statusText, " +", " ")
SendViaClipboard(statusText)

Sleep, 2000

WinClose, Buddy List ahk_class gdkWindowToplevel
