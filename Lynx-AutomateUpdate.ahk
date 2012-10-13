#include FcnLib.ahk

;automatic updater clicker


if NOT IsAhkCurrentlyRunning("Lynx-Update.ahk")
{
   SleepMinutes(1)
   RunAhk("Lynx-Update.ahk")
}

TimeToStop := CurrentTimePlus(10000) ; + 1 hour
Loop
{
   if ForceWinFocusIfExist("Lynx Upgrade Assistant")
      Send, {ENTER}
      ;Click()

   if ( TimeToStop < CurrentTime() )
      ExitApp

   SleepSeconds(5)
}
ExitApp
