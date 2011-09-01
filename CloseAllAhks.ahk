#include FcnLib.ahk

;close all ahks, as forcefully as needed

ExcludeRegEx=%1%
RunAhkAfterClose=%2%

if NOT ExcludeRegEx
   ExcludeRegEx=^$

timer:=starttimer()

DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.

;Close as many as gracefully as we can
CloseAllAhkProcesses("gracefully", excludeRegEx)
CloseAllAhkProcesses("gracefully", excludeRegEx)

WinGet, id, LIST, - AutoHotkey

ret:=CloseAllAhkProcesses("forcefully", excludeRegEx)

totaltime:=elapsedtime(timer)

idleAhk=C:\Dropbox\AHKs\StartIdleAhks.ahk
if FileExist(idleAhk)
   Run, %idleAhk%, C:\Dropbox\AHKs

CloseAllAhkProcesses(options, excludeRegEx)
{
   returned:=false
   WinGet, id, LIST, - AutoHotkey
   Loop, %id%
   {
      thisID:=id%A_Index%
      ahkIdStr=ahk_id %thisID%
      title:=wingettitle(ahkIdStr)
      regexmatch(title, "([A-Za-z0-9]*\.ahk)", smalltitle)
      pid := WinGet("pid", ahkIdStr)

      if NOT InStr(title, A_ScriptName) AND NOT RegExMatch(title, ExcludeRegEx)
      {
         returned:=true
         if InStr(options, "graceful")
            WinClose, %ahkIdStr%
         if InStr(options, "forceful")
            Process, Close, %pid%
      }
   }
   return returned
}

;doesn't work, but this would be nice someday
;addvartotrace(varName)
;{
   ;global
   ;addtotrace(varName, %varName%)
;}
