#include FcnLib.ahk

;global commandSuppressCrlf
;global commandDelMatch
;global commandNewLine
;global commandTab
;global commandSpace

debugCmd=#debug
commandSuppressCrlf=#suppresscrlf
commandNewLine=#newline
commandDeleteLine=#delline
commandDeleteMatch=#delmatch
commandSpace=#space
commandTab=#tab

infile=%1%
refile=%2%
outfile=%3%

path=C:\My Dropbox\AHKs\REFP\
if (infile=="")
   infile=%path%in1.txt
;else
   ;infile=%path%%infile%
if (refile=="")
   refile=%path%regex1.txt
;else
   ;refile=%path%%refile%
if (outfile=="")
   outfile=%path%out1.txt
;else
   ;outfile=%path%%outfile%
tempfile=%path%temp1.txt

;TODO ensure that the folder to outfile exists
;TODO prepend the AHKs\REFP path onto the front of the path - this is done, but is it done well?

;TODO usage warning
;  either return text or errord (does return send text to the cmd?)

;make an archived copy of every REFP that is run
timestamp := CurrentTime("hyphenated")
backupFile=%path%archive\%timestamp%.txt
FileCopy, %refile%, %backupFile%

if NOT FileExist(infile)
{
   infile=%path%%infile%
   refile=%path%%refile%
   outfile=%path%%outfile%
}
FileAppend, testing, %outfile%
FileAppend, testing, %tempfile%

if NOT FileExist(infile)
   fatalerrord("infile does not exist", infile)
if NOT FileExist(refile)
   fatalerrord("refile does not exist", refile)
if NOT FileExist(outfile)
   fatalerrord("outfile cannot be written to", refile)
if NOT FileExist(tempfile)
   fatalerrord("tempfile cannot be written to", refile)
;errord(infile, refile, outfile)

FileDelete, %outfile%
FileDelete, %tempfile%

Loop
{
   ReplaceLineNo:=A_Index*2
   NeedleLineNo:=ReplaceLineNo-1
   FileReadLine, Needle%A_Index%, %refile%, %NeedleLineNo%
   if ErrorLevel
      break
   FileReadLine, Replace%A_Index%, %refile%, %ReplaceLineNo%
   if ErrorLevel
      break
   ;MsgBox, 4, , Line #%A_Index% is "%line%".  Continue?
   if (Replace%A_Index% == debugCmd OR Needle%A_Index% == debugCmd)
      break
   TotalRegExs++
}

FileCopy, %infile%, %tempfile%, 1
Loop %TotalRegExs%
{
   FileMove, %outfile%, %tempFile%, 1
   i=%A_Index%
   Loop, read, %tempfile%
      totalTempLines:=A_Index

   Loop, read, %tempfile%
   {
      suppressCrlf:=false
      thisTempLineNum:=A_Index
      ;debug("line nums", thistemplinenum, totaltemplines)

      ;if we're on the last line, suppress the crlf
      if (thisTempLineNum == totalTempLines)
         suppressCrlf:=true

      ;determine if this line is a match
      if NOT RegExMatch(A_LoopReadLine, Needle%i%)
         LineToPrint=%A_LoopReadLine%
      else
      {
         thisReplace := Replace%i%
         thisNeedle := Needle%i%

         if InStr(thisReplace, commandDeleteLine)
            continue
         if InStr(thisReplace, commandSuppressCrlf)
            suppressCrlf:=true

         ;debug(thisReplace)
         ;debug(commandDeleteLine)

         ;strip the commands out of the needle and replace strings
         ;debug(thisneedle, thisreplace)
         thisReplace:=StripCommands(thisReplace)
         thisNeedle :=StripCommands(thisNeedle)
         thisReplace:=StringReplace(thisReplace, commandSuppressCrlf)
         thisReplace:=StringReplace(thisReplace, commandDelMatch)
         ;debug(thisneedle, thisreplace)

         ;thisReplace:=StringReplace(thisReplace, commandNewLine, "`n", 1)
         ;thisReplace:=StringReplace(thisReplace, commandTab, "`t")
         ;thisReplace:=StringReplace(thisReplace, commandSpace, " ")

         ;perform the replacement now
         LineToPrint:=RegExReplace(A_LoopReadLine, thisNeedle, thisReplace)
      }

      if NOT suppressCrlf
         LineToPrint.="`n"

      FileAppend, %LineToPrint%, %outfile%

      ;debug(i, replace%i%, thisreplace, A_LoopReadLine, Needle%i%)
   }
}

StripCommands(string)
{
   global commandSuppressCrlf
   global commandDelMatch
   global commandNewLine
   global commandTab
   global commandSpace
   commandTab=#tab

   ;string:=StringReplace(string, commandSuppressCrlf)
   ;string:=StringReplace(string, commandDelMatch)
   string:=StringReplace(string, commandNewLine, "`n", 1)
   string:=StringReplace(string, commandTab, "`t")
   string:=StringReplace(string, commandSpace, " ")

   return string
}
