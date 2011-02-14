
#include FcnLib.ahk
deletetracefile()
addtotrace("now this really works,,,2")
debug()
DeDupFilesInFolder("C:\My Dropbox\Android\")
DeDupFilesInFolder(folderPath)
{
 folderPath=%folderPath%*.*
 e"> Loop, %folderPath%, 0, 1
 {
  addtotrace("hi")
  leftfile:=A_LoopFileFullPath
  Loop,%folderPath%, 0, 1
  {
    rightfile:=A_LoopFileFullPath
    if (%leftfile% <> %rightfile%)
     addtotrace("exists", leftfile, rightfile)
    if IsFileEqual(leftfile, rightfile)
     addtotrace("IS EQUAL", leftfile, rightfile)
  }
 }
}
