#include FcnLib.ahk

AssertDirExist(true,  A_ProgramFiles, "Program Files")
AssertDirExist(true,  A_WinDir, "Windows Dir")
AssertDirExist(false, "C:\dirifaasdfkh", "Fake-o")
AssertDirExist(false, "C:\Program Files\asdfakjsh", "Sub fake-o")

AssertDirExist(assert, var, description)
{
   if (DirExist(var)<>assert)
      Msgbox, Folder %description% was not as expected
}


;AssertDirExist(true,  A_ProgramFiles)

;;if (InStr(FileExist(A_ProgramFiles), "D"))
    ;;Msgbox, Program Files Exists
;;if (InStr(FileExist(A_WinDir), "D"))
    ;;Msgbox, Windows Dir Exists

;AssertDirExist(assert, var, description)
;{
   ;if (DirExist(var)<>assert)
      ;debug("program files doesn't exist")
;}
