#include FcnLib.ahk

;remove conflicted dropbox files, (if possible)
;and record the remaining conflicted copies in the dropbox

Loop, C:\Dropbox\*, 0, 1
{
   thisFile := A_LoopFileName
   thisFilePath := A_LoopFileFullPath
   count++
   if RegExMatch(thisFile, "'s conflicted copy \d\d\d\d-\d\d-\d\d\)\.")
   {
      ;clean it up, if possible
      if RegExMatch(thisFilePath, "^\QC:\Dropbox\Programs\FirefoxPortable\Data\profile\\E")
      {
         FileDelete(thisFilePath)
         if NOT FileExist(thisFilePath)
            continue
      }

      ;cleanup not possible, record it
      conflictedList .= "`n" . thisFilePath
      matchCount++
   }
}

;addtotrace("number of files:", count, matchCount)
outputFile=C:\Dropbox\AHKs\gitExempt\morning_status\dropboxInfo.txt
message=There are %matchCount% conflicted copy files in the Dropbox.
if (matchCount > 15)
   FileAppendLine(message, outputFile)
errord("nolog", message, conflictedList)
ExitApp

;TODO we should probably move the cleanup portions of the script to a function
;but I'm not sure how I'd like that to look yet
;probably should do that later, when we get multiple sections

;TODO I think I'd be more comfortable with two loops, but that seems like it would be copypasta

IsConflictedFile()
{
return bool
}

RemoveConflictedFile()
{
return bool
}
