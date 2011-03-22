#include FcnLib.ahk

RunProgram("DesktopSidebar")
ExitApp

;trying to make a function like:
;RunProgram(appName)
;{

;}

;usage:
;RunProgram("opera")
; or pidgin or ie or chrome or whatever

;DeleteTraceFile()
;AddToTrace(CurrentTime("hyphenated"))

;ini=gitExempt\folderinfo.ini

;IniWrite(ini, A_ComputerName, "ProgramFiles", "C:\Program Files\")
;IniWrite(ini, A_ComputerName, "DesktopSidebar", "C:\Program Files (x86)\Desktop Sidebar\dsidebar.exe")

;;Run,C:\Program Files (x86)\Desktop Sidebar\dsidebar.exe

;debug(FileGetLocation("ProgramFiles"))

;AddToTrace(FileRead(ini))
;SleepSeconds(1)
;ExitApp

;RunProgram(appName)
;{
   ;;if appname is a full path, save it to the ini

   ;ini=gitExempt\folderinfo.ini
   ;appFilename := IniRead(ini, "NICKNAMES", appName)
   ;Run, %path%
;}

;RunProgram(appName)
;{
   ;;this is a bad idea, FileGetLocation will never be reused
   ;path := FileGetLocation()
   ;if NOT path
      ;return "ERROR"
   ;Run, %path%
;}

FileGetLocation()
{
;first check the ini for this pc
;then check the ini for all other pcs
;   (check std and x86 dirs)

;then maybe log error out
;then scan the entire program files folder
}

;TESTME
;IniRead(file, section, key)
;{
   ;;TODO put this in the read write and delete fcns
   ;global A_IniFile
   ;if (file == "")
      ;file:=A_IniFile
   ;if (file == "")
      ;fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no filename was provided for writing the ini to")
   ;if (section == "")
      ;section:="default"

   ;IniRead, value, %file%, %section%, %key%
   ;return value
;}

;TESTME
FileCreate(text, file)
{
   FileDelete(file)
   FileAppend(text, file)
}
