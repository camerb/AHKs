#include FcnLib.ahk

;C:\Dropbox\.dropbox.cache
;folderPattern=C:\Documents and Settings\Administrator\Application Data\Dropbox\cache\*
FileDeleteDirForceful("C:\Dropbox\.dropbox.cache\")
FileDeleteDirForceful("C:\Documents and Settings\Administrator\Application Data\Dropbox\cache\")

;delete as many files as we possibly can (typically difficult in windows)
;Loop, %folderPattern%, , 1
;{
   ;FileDelete, %A_LoopFileFullPath%
;}

;;delete all the folders that we can
;Loop, %folderPattern%, 2, 1
;{
   ;FileRemoveDir, %A_LoopFileFullPath%, 1
;}


