#SingleInstance Off
#include FcnLib.ahk
#SingleInstance Off

;locate and run program, if possible

pathOrAppFilenameOrAppNickname=%1%


;TODO search dropbox programs folder, too

ini=gitExempt\folderinfo.ini
path:=pathOrAppFilenameOrAppNickname

if RegExMatch(path, ".\:\\.*\\(.*)", match)
   appFilename:=match1

TestProgramPath(appFilename, path)

path := StringReplace(path, "\Program Files (x86)\", "\Program Files\")
TestProgramPath(appFilename, path)

path := StringReplace(path, "\Program Files\", "\Program Files (x86)\")
TestProgramPath(appFilename, path)

;at this point, we have tried all of the valid paths we can think of
; this is either an invalid path, just a filename, or a nickname of something we already know of
appName := pathOrAppFilenameOrAppNickname
path=

;look up the filename that corresponds to this nickname
appFilename := IniRead(ini, "NICKNAMES", appName)

;it turns out that our assumption that the item passed in is an app nickname is wrong
; it is probably a filename
if (appFilename == "ERROR")
{
   appFilename:=pathOrAppFilenameOrAppNickname
   appName=
}

;look up the path specific to this PC
path := IniRead(ini, A_ComputerName, appFilename)
TestProgramPath(appFilename, path, true)

appFilename .= ".exe"
path := IniRead(ini, A_ComputerName, appFilename)
TestProgramPath(appFilename, path, true)

;TODO guess based on the path specified for other computers
;TODO scan program files dir
;TODO and also try the dropbox\programs folder

delog("tried run program", pathOrAppFilenameOrAppNickname, A_ScriptName, A_LineNumber, A_ThisFunc, "could not find the directory or one like it", "app might not be installed, or the path might not be pointed at the program files dir")

;check if the path is correct. if so, then run it and exit
TestProgramPath(appFilename, path, noWrite=false)
{
   global ini
   if FileExist(path)
   {
      Run, %path%
      if NOT noWrite
         if appFilename
            IniWrite(ini, A_ComputerName, appFilename, path)
      ExitApp
   }
}
