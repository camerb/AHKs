#include FcnLib.ahk

debug( SuccessfullyCompiles("C:\Dropbox\AHKs\FcnLib.ahk"), SuccessfullyCompiles("C:\Dropbox\AHKs\CompileErrors.ahk"))
;;Run, %ahk%, , UseErrorLevel
;Run, %exe%, , UseErrorLevel
;debug(ERRORLEVEL)

;Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]

SuccessfullyCompiles(ahkPath)
{
   testOutPath=%A_Temp%\compileahk.txt
   testAhk=%A_Temp%\compileahk.ahk

   if NOT FileExist(ahkPath)
      return false

   text=
   (
   FileAppend, %ahkPath%, %testOutPath%
   ExitApp

   #include %ahkPath%
   )

   FileCreate("started compile text`n", testOutPath)
   FileCreate(text, testAhk)

   ;Run, %testAhk%
   RunWait, %testAhk%
   Sleep, 500

   results:=FileRead(testOutPath)
   FileDelete(testOutPath)
   ;debug(results)
   returned := !!InStr(results, ahkPath)
   return !!InStr(results, ahkPath)
}
