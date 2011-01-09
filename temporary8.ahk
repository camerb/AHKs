#include FcnLib.ahk



DeleteTraceFile()
AddToTrace(CurrentTime("hyphenated"))

ini=gitExempt\folderinfo.ini
val=C:\Program Files\

IniWrite(ini, A_ComputerName, "ProgramFiles", "C:\Program Files\")
IniWrite(ini, A_ComputerName, "DesktopSidebar", "C:\Program Files (x86)\Desktop Sidebar\dsidebar.exe")

;Run,C:\Program Files (x86)\Desktop Sidebar\dsidebar.exe

debug(FileGetLocation("ProgramFiles"))

AddToTrace(FileRead(ini))
SleepSeconds(1)
ExitApp

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
   ;global A_IniFile
   ;if (file == "")
      ;file:=A_IniFile
   ;if (section == "")
      ;section:="default"
   IniWrite, %value%, %file%, %section%, %key%
}

;TESTME
FileCreate(text, file)
{
   FileDelete(file)
   FileAppend(text, file)
}
