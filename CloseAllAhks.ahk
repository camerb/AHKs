#include FcnLib.ahk

;close all ahks, as forcefully as needed

ExcludeRegEx=%1%
RunAhkAfterClose=%2%

if NOT ExcludeRegEx
   ExcludeRegEx=^$

addtotrace("restarted script - grey line")
timer:=starttimer()

DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
;WinClose RemoteWidget.ahk - AutoHotkey  ; Update this to reflect the script's name (case sensitive).

;Close as many as gracefully as we can
CloseAllAhkProcesses("gracefully", excludeRegEx)

;do some debugging, just to make sure we're good (fresh development)
WinGet, id, LIST, - AutoHotkey
if (id != 1)
   AddToTrace(id, "AHKs are open after graceful close, yellow line")

ret:=CloseAllAhkProcesses("forcefully", excludeRegEx)
if ret
   AddToTrace("orange line: had to close an ahk forcefully")

totaltime:=elapsedtime(timer)
addtotrace("Time it took for processes to close:", totaltime)

;debug("about to run main ahk files again")
;RunAhk("""C:\My Dropbox\AHKs\StartIdleAhks.ahk""", )
idleAhk=C:\My Dropbox\AHKs\StartIdleAhks.ahk
if FileExist(idleAhk)
   Run, %idleAhk%, C:\My Dropbox\AHKs

CloseAllAhkProcesses(options, excludeRegEx)
{
   returned:=false
   WinGet, id, LIST, - AutoHotkey
   AddToTrace(id, "AHKs are open")
   Loop, %id%
   {
      thisID:=id%A_Index%
      ahkIdStr=ahk_id %thisID%
      title:=wingettitle(ahkIdStr)
      regexmatch(title, "([A-Za-z0-9]*\.ahk)", smalltitle)
      pid := WinGet("pid", ahkIdStr)
      addtotrace(pid, smallTitle)

      if NOT InStr(title, A_ScriptName) AND NOT RegExMatch(title, ExcludeRegEx)
      {
         returned:=true
         addtotrace("ok, lets close it")
         if InStr(options, "graceful")
            WinClose, %ahkIdStr%
         if InStr(options, "forceful")
            Process, Close, %pid%
      }
   }
   return returned
}

;doesn't work, but this would be nice
;addvartotrace(varName)
;{
   ;global
   ;addtotrace(varName, %varName%)
;}
