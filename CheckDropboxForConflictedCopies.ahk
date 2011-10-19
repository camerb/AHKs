#include FcnLib.ahk

;'s conflicted copy 2011-10-17).
; perl (Toshimi Laptop's conflicted copy 2009-12-19).vim C:\Dropbox\Programs\Vim\vim72\syntax\perl (Toshimi Laptop's conflicted copy 2009-12-19).vim
;Loop, C:\Dropbox\AHKs\gitExempt\logs\*, 0, 1
Loop, C:\Dropbox\*, 0, 1
{
   thisFile := A_LoopFileName
   count++
   if RegExMatch(thisFile, "'s conflicted copy \d\d\d\d-\d\d-\d\d\)\.")
   {
      ;addtotrace(thisfile, A_LoopFileFullPath)
      matchCount++
   }
}

;addtotrace("number of files:", count, matchCount)
outputFile=C:\Dropbox\AHKs\gitExempt\morning_status\dropboxInfo.txt
message=There are %matchCount% conflicted copy files in the Dropbox.
if (matchCount > 15)
   FileAppendLine(message, outputFile)
