#include FcnLib.ahk
#NoTrayIcon

ScriptCheckin("Started")

Loop
{
   DontWaitToClosePreviousInstance("soffice.exe")
   DontWaitToClosePreviousInstance("AutoHotkey.exe")
   DontWaitToClosePreviousInstance("AutoHotkey.ahk")
   DontWaitToClosePreviousInstance("RemoteWidget.ahk")
   DontWaitToClosePreviousInstance("KeepNetworkHardDrivesActive.ahk")
   DontWaitToClosePreviousInstance("UpdateRemoteWidget.ahk")

   Sleep, 250
   ScriptCheckin("Watching")
}

;inf loop, here's the end
ExitApp

DontWaitToClosePreviousInstance(ahkToClose)
{
   IfWinExist, %ahkToClose% ahk_class #32770, Could not close the previous instance of this script
   {
      WinActivate
      WinWaitActive
      ClickButton("&No")
   }
}

;#include Firefly-FcnLib.ahk
