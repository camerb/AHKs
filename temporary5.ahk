#include FcnLib.ahk


deletetracefile()

timer:=StartTimer()
DeDupFilesInFolder("C:\My Dropbox\Android\sd\Documents\")
AddToTrace("green line", "time to complete was", ElapsedTime(timer))

DeDupFilesInFolder(folderPath)
{
   folderPath := EnsureEndsWith(folderPath, "\")
   folderPath=%folderPath%*.*
   Loop, %folderPath%, 0, 1
   {
      addtotrace("hi")
      leftfile:=A_LoopFileFullPath
      Loop, %folderPath%, 0, 1
      {
         rightfile:=A_LoopFileFullPath

         if (leftfile <> rightfile)
         {
            ;addtotrace("exists", leftfile, rightfile)

            if IsFileEqual(leftfile, rightfile)
               addtotrace("IS EQUAL", leftfile, rightfile)
         }
      }
   }
}

`:: ExitApp
