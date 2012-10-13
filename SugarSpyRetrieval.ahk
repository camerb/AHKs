#include FcnLib.ahk
#NoTrayIcon

;retrieval of sugar spy info
Loop
{
   Sleep, 5000
   Loop, T:\Update and Install Logs\other\archive\ss\*
   {
      Sleep, 500
      sourceFile := A_LoopFileFullPath
      destFile=C:\DataExchange\Sugar\%A_LoopFileName%
      FileMove(sourceFile, destFile)
   }
}
