;Items in this file commonly used temporarily, but are considered an unfinished work.
;Removing the include for GhettoFcnLib will give you a good idea of what items are rough or unfinished

#include FcnLib.ahk

OpenCsv(csvFile)
{
   Run, scalc.exe "%csvFile%"
   ForceWinFocus("Text Import")

   ;Time to process the add might increase if it is a huge file
   ;Sleep, 2000
   Sleep, 200

   ;Shouldn't have to enable commas if it is .csv, only if it is .txt
   ;Send, {TAB 2}c

   Send, {ENTER}
   ForceWinFocus("OpenOffice")
}
