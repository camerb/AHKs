#include FcnLib.ahk

AssignGlobals()
DeletePrepFolder()
CopyFilesToPrepFolder()
RunTestsFromPrepFolder()
debug("finished packaging for release")
CopyFilesToPrepFolder()

DeletePrepFolder()
{
   global prepFolder
   FileDeleteDirForceful(prepFolder)
}

CopyFilesToPrepFolder()
{
   global fileList
   global devFolder
   global prepFolder

   DeletePrepFolder()
   Loop, parse, fileList, `n
   {
      thisFile := A_LoopField
      source=%devFolder%%thisFile%
      dest=%prepFolder%%thisFile%
      FileCopy(source, dest)
   }
}

RunTestsFromPrepFolder()
{
   global prepFolder
   global testsFile
   RunWait, %testsFile%, %prepFolder%
}

AssignGlobals()
{
   global fileList
   global devFolder
   global prepFolder
   global testsFile

   devFolder=C:\Dropbox\AHKs\camerb-OCR-function\
   prepFolder=C:\Dropbox\Public\camerb-ahk-net\OCR\prepForRelease\

fileList=
(
CMDret.ahk
cmdret.dll
djpeg.exe
Gdip.ahk
gocr.exe
OCR.ahk
OCR-example.ahk
OCR-preview.ahk
OCR-tests.ahk
)
;NOTE that the tests file should always be the last one

   Loop, parse, fileList, `n
   {
      thisFile := A_LoopField
      testsFile=%prepFolder%%thisFile%
   }
}
