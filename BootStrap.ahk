#include FcnLib.ahk

Run, Startup%A_ComputerName%.ahk

RunAhk("StartIdleAhks.ahk")

;apps that should run on all my computers
RunProgram("C:\My Dropbox\Programs\CLCL\CLCL.exe")
RunProgram("Dropbox.exe")

if NOT IsVM()
{
   RunProgram("C:\Program Files\Desktop Sidebar\dsidebar.exe")
   RunProgram("C:\Program Files (x86)\WinSplit Revolution\WinSplit.exe")
   RunProgram("C:\Program Files\FindAndRunRobot\FindAndRunRobot.exe")
}
;Openoffice launcher

if (GetOS() = "WIN_7")
   RunProgram("C:\My Dropbox\Programs\Aura Beta 2\Aura.exe")
