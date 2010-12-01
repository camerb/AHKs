#include FcnLib.ahk

;ahk babysitter

path=C:\DataExchange\tempahks
FileCreateDir, %path%
FileAppend, msgbox one, %path%\one.ahk
FileAppend, msgbox two, %path%\two.ahk

Loop, %path%\*.ahk
{
   ;copy file contents to a new ahk and run it
   tempahk=%A_WorkingDir%\Scheduled-%A_LoopFileName%
   FileCopy, %A_LoopFileFullPath%, %tempahk%
   FileAppend, `n#include FcnLib.ahk`nSelfDestruct(), %tempahk%
   Run, %tempahk%
   FileDelete, %A_LoopFileFullPath%

   ;wait for the ahk to self-destruct (when it's finished running)
   while (FileExist(tempahk))
   {
      Sleep 100
   }
}
