#include FcnLib.ahk

   asapAhk=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.ahk
   asapTxt=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.txt
   lock=%A_WorkingDir%\scheduled\%A_ComputerName%\InProgress.lock
   deleteLock=%A_WorkingDir%\scheduled\%A_ComputerName%\DeleteLock.now

   ;move the asaps so that they are normal
   bothAsaps=%asapAhk%,%asapTxt%
   Loop, parse, bothAsaps, CSV
   {
      if FileExist(A_LoopField)
      {
         time:=CurrentTime("hyphenated")
         newFileName=%A_WorkingDir%\scheduled\%A_ComputerName%\%time%.ahk
         ;TODO use FileGetModified Date/time
         FileMove(A_LoopField, newFileName)
      }
   }

   ;abort the current macro
   ;cause we got a command to delete the lockfile
   if FileExist(deletelock)
   {
      FileDelete(lock)
      FileDelete(deletelock)
   }

   if NOT FileExist(lock)
   {
      ;check if time to run an ahk
      asapAhk=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.ahk
      asapTxt=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.txt
      if FileExist(asapTxt)
         FileMove(asapTxt, asapAhk, "overwrite")

      ;TODO put all this crap into another ahk, so that persistent doesn't halt while we're babysitting other ahks
      Loop, %A_WorkingDir%\scheduled\%A_ComputerName%\*.ahk
      {
         filedate := A_LoopFileName
         filedate := RegExReplace(filedate, "\.ahk$")
         filedate := DeformatTime(filedate)

         ;check to make sure filedate is a number and is 14 long
         if ( strlen(filedate) != 14 )
            continue
         if NOT filedate is integer
            continue
         if NOT CurrentlyAfter(filedate)
            continue

         ;debug(filedate)

         compilingPath=%A_WorkingDir%\scheduled\%A_ComputerName%\Compiling\%A_LoopFileName%
         errorsPath   =%A_WorkingDir%\scheduled\%A_ComputerName%\Errors\%A_LoopFileName%
         runningPath  =%A_WorkingDir%\scheduled\%A_ComputerName%\Running\%A_LoopFileName%
         finishedPath =%A_WorkingDir%\scheduled\%A_ComputerName%\Finished\%A_LoopFileName%

         ;debug(compilingPath)
         FileMove(A_LoopFileFullPath, compilingPath)
         FileAppend("`n#include FcnLib.ahk", compilingPath)

         ;TODO write a testCompile function
         ;if errorsCompiling
         ;{
            ;FileMove(A_LoopFileFullPath, errorsPath)
            ;continue
         ;}

         ;Prep for run (tell him that after he's done running, he's got to move himself to the finished folder)
         FileMove(compilingPath, runningPath)
         lastLine=`nFileMove("%runningPath%", "%finishedPath%")
         FileAppend(lastLine, runningPath)

         ;Run that sucka!
         RunAhk(runningPath)
      }
   }
