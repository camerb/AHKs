#include FcnLib.ahk

iniMostRecentTime("Ran Bootstrap (most recent time)") ;track the last time it was reloaded
iniPP("Ran Bootstrap (number of times)") ;count all the times it was reloaded

SpiffyMute()

;TODO, make the three numbered supervisionCore files
;Loop, 3
;{
   supervisionCore=SupervisionCore%A_Index%.exe
   supervisionCore=SupervisionCore1.exe
   if FileExist(supervisionCore)
      Run, %supervisionCore%
;}

startupAhk=Startup%A_ComputerName%.ahk
if FileExist(startupAhk)
   RunAhk(startupAhk)

RunAhk("StartIdleAhks.ahk")

;apps that should run on all my computers
RunProgram("C:\Dropbox\Programs\CLCL\CLCL.exe")
RunProgram("Dropbox.exe")

if NOT IsVM()
{
   RunProgram("C:\Program Files\Desktop Sidebar\dsidebar.exe")
   RunProgram("C:\Program Files (x86)\WinSplit Revolution\WinSplit.exe")

   ;TODO turn this into RunProgramOneInstance() or make an options param
   if NOT ProcessExist("FindAndRunRobot.exe")
      RunProgram("C:\Program Files\FindAndRunRobot\FindAndRunRobot.exe")

   RunAhk("ImageIt.ahk")
}

;TODO Openoffice launcher, if available

if (GetOS() = "WIN_7")
   RunProgram("C:\Dropbox\Programs\Aura Beta 2\Aura.exe")
