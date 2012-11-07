#include FcnLib.ahk

FireflyCheckin("Persistent2 - DEPRECATED PARAM red line", "Started")

Loop
{
   DontWaitToClosePreviousInstance("soffice.exe")
   DontWaitToClosePreviousInstance("AutoHotkey.exe")
   DontWaitToClosePreviousInstance("AutoHotkey.ahk")
   DontWaitToClosePreviousInstance("RemoteWidget.ahk")
   DontWaitToClosePreviousInstance("KeepNetworkHardDrivesActive.ahk")

   Sleep, 250
   FireflyCheckin("Persistent2 - DEPRECATED PARAM red line", "Watching")
}

DontWaitToClosePreviousInstance(ahkToClose)
{
   IfWinExist, %ahkToClose% ahk_class #32770, Could not close the previous instance of this script
   {
      WinActivate
      WinWaitActive
      ClickButton("&No")
   }
}
