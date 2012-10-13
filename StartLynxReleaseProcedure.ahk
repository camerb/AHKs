#include FcnLib.ahk

;Start the Lynx Release Procedure

zipFile := Prompt("Which file should we start testing?")
;FastNotification("Starting the Lynx Release Procedure")

zipFile := EnsureEndsWith(zipFile, ".zip")
sourcePath=L:\Lynx Department\Staff\Jason\%zipFile%

computerList=test,release,t-2008,t-2003,t-1,t-800
Loop, parse, computerList, CSV
{
   thisComputer := A_LoopField
   destPath=\\%thisComputer%\c$\temp\rc.zip
   FileDelete(destPath)
   FileCopy(sourcePath, destPath)
}

FastNotification("Finished copying release candidate files")


EXITAPP
;TODO put this part in at the end later, this will help us to keep things tidy
computerList=kp,test,release,t-2008,t-2003,t-1,t-800
Loop, parse, computerList, CSV
{
   thisComputer := A_LoopField
   destPath=\\%thisComputer%\c$\temp\rc.zip
   FileDelete(destPath)
}
