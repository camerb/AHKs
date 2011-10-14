#include FcnLib.ahk

;check folder for duplicate files

;TODO delete the duplicates and note them in the trace file
;maybe we should add priority folders to keep the file in
;or we could just have a method that runs afterward to move files to the place where they should be

deletetracefile()

timer:=StartTimer()
DeDupFilesInFolder("C:\Dropbox\Android\sd\Documents\")
AddToTrace("green line", "time to complete was", ElapsedTime(timer))
ExitApp

DeDupFilesInFolder(folderPath)
{
   folderPath := EnsureEndsWith(folderPath, "\")
   folderPath=%folderPath%*.*
   Loop, %folderPath%, 0, 1
   {
      ;addtotrace("hi")
      leftfile:=A_LoopFileFullPath
      Loop, %folderPath%, 0, 1
      {
         rightfile:=A_LoopFileFullPath

         if (leftfile <> rightfile)
         {
            ;addtotrace("exists", leftfile, rightfile)

            if IsFileEqual(leftfile, rightfile)
            {
               addtotrace("IS EQUAL", leftfile, rightfile)
            }
         }
      }
   }
}

`:: ExitApp
