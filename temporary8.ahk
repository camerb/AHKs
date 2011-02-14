#include FcnLib.ahk

;RunProgram("DesktopSidebar") - using a smart ini

;trying to make a function like:
;LaunchProgram(appName)
;{

;}

;usage:
;LaunchProgram("opera")
; or pidgin or ie or chrome or whatever

DeleteTraceFile()
AddToTrace(CurrentTime("hyphenated"))

ini=gitExempt\folderinfo.ini

IniWrite(ini, A_ComputerName, "ProgramFiles", "C:\Program Files\")
IniWrite(ini, A_ComputerName, "DesktopSidebar", "C:\Program Files (x86)\Desktop Sidebar\dsidebar.exe")

;Run,C:\Program Files (x86)\Desktop Sidebar\dsidebar.exe

debug(FileGetLocation("ProgramFiles"))

AddToTrace(FileRead(ini))
SleepSeconds(1)
ExitApp

FileGetLocation()
{
;first check the ini for this pc
;then check the ini for all other pcs
;   (check std and x86 dirs)

;then maybe log error out
;then scan the entire program files folder
}

IniDelete(file, section, key="")
{
   if (key == "")
      IniDelete, %file%, %section%
   else
      IniDelete, %file%, %section%, %key%
}

;TESTME
IniWrite(file, section, key, value)
{
   ;TODO put this in the read write and delete fcns
   global A_IniFile
   if (file == "")
      file:=A_IniFile
   if (file == "")
      fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no filename was provided for writing the ini to")
   if (section == "")
      section:="default"

   IniWrite, %value%, %file%, %section%, %key%
   ;TODO test if the file is there
}

;TESTME
FileCreate(text, file)
{
   FileDelete(file)
   FileAppend(text, file)
}
