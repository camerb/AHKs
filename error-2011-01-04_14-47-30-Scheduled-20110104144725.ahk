
#include FcnLib.ahk

debug("hello from cr-48")



;debug("silent log", "started to ruspan id="sites-page-title" dir="ltr">remoteahkZZZnewlineZZZZZZnewlineZZZZZZnewlineZZZ
;timestamp := CurrentTime("hyphenated")
;filename=C:\My Dropbox\Public\output.txt
;FileAppendLine(timestamp, filename)

FileAppend(text, file)
{
   if NOT FileExist(file)
      fatalErrord("file doesn't exist")
   FileAppend, %text%, %file%
}

FileAppendLine(text, file)
{
   text.="`n"
   return FileAppend(text, file)
}

FileCopy(source, dest, options="")
{
   if InStr(options, "overwrite")
      overwrite=1
   ;TODO ensure target dir exists
   FileCopy, %source%, %dest%, %overwrite%
}

FileDelete(file)
{
   ;should we even bother returning an error if the file is already gone? i think not... maybe TODO log it
   if NOT FileExist(file)
      return

   FileDelete, %file%
}
#include FcnLib.ahk
SelfDestruct()