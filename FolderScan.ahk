#include FcnLib.ahk

;folder scan function
;FolderScan("C:\My Dropbox\AHKs\*", "conflicted", "paths")
;FolderScan("C:\My Dropbox\AHKs\*", ".*;.*(TODO|WRITEME)", "fileContents")
;FolderScan("C:\My Dropbox\AHKs\*", ".*;.*WRITEME", "fileContents")
FolderScan("C:\My Dropbox\AHKs\*", "listview", "fileContents")
;FolderScan("", "", "GUI")

;note that the path is actually a haystack, preserving the search(haystack, needle) ordering that is common throughout AHK
FolderScan(path, needle, options="files folders regex")
{
   AddToTrace("grey line")
   ;options=files/fileContents folders/paths folderPaths regex contains gui

   ;TODO how do we determine if they forgot the wildcard characters at the end? they might only want to scan a certain file type for file contents
   ;path.=*

   ;files
   Loop, %path%, 0, 1
   {
      thisPath := A_LoopFileFullPath
      thisFilename := A_LoopFileName
      ;if RegExMatch(thisPath, "(" . needle . ")", match)
      ;match the path
      ;if RegExMatch(thisPath, needle, match)
         ;AddToTrace(thisPath)

      lineNum=0
      Loop, read, %thisPath%
      {
         lineNum++
         thisLine := A_LoopReadLine
         if RegExMatch(thisLine, needle, match)
            AddToTrace(thisFilename, lineNum, thisLine)
      }
   }

   ;folders
   Loop, %path%, 2, 1
   {
   }
}


