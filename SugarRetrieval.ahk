#include FcnLib.ahk
#NoTrayIcon

;retrieval of sugar spy info

pcList=lynx151,lynx152,lynx153,phosphorus
Loop
{
   Sleep, 5000
   Loop, parse, pcList, CSV
   {
      pc := A_LoopField
      Loop, \\%pc%\c$\temp\archive\ss\*
      {
         Sleep, 500
         sourceFile := A_LoopFileFullPath
         destFile=C:\DataExchange\Sugar\%A_LoopFileName%
         FileMove(sourceFile, destFile)
      }
   }

   Loop, T:\Update and Install Logs\other\archive\ss\*
   {
      Sleep, 500
      sourceFile := A_LoopFileFullPath
      destFile=C:\DataExchange\Sugar\%A_LoopFileName%
      FileMove(sourceFile, destFile)
   }
}
