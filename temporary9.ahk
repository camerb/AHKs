#include FcnLib.ahk
#include firefly-FcnLib.ahk

joe:=IniFolderRead("C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\joe", "joe", "ff")
if (A_ComputerName == "PHOSPHORUS")
   debug(joe)
joe:=IniFolderRead("C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\joe", "joe", "folder")
if (A_ComputerName == "PHOSPHORUS")
   debug(joe)
;IniFolderWrite("C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\joe", "joe", "james", A_ComputerName)
;Sleep, 5600
;IniFolderWrite("C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\joe", "bob", "sally", "700")


   ffList:="C:\Program Files\Mozilla Firefox\firefox.exe,C:\Program Files (x86)\Mozilla Firefox\firefox.exe,C:\Dropbox\Programs\FirefoxPortable\FirefoxPortable.exe,C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe"
   Loop, parse, ffList, CSV
   {
      if FileExist(A_LoopField)
      {
         firefoxPath:=A_LoopField
         break
      }
   }

folder:=ParentDir(firefoxPath)
folder:=EnsureEndsWith(folder, "\")
iniPath=%folder%application.ini
version:=IniRead(iniPath, "App", "Version")

;IniFolderWrite("C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\joe", "joe", "ff", version)
;IniFolderWrite("C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\joe", "joe", "folder", folder)



;debug(version)
