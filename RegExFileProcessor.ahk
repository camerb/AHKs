#include FcnLib.ahk

commandDebug=#debug
commandSuppressCrlf=#suppresscrlf
commandNewLine=#newline
commandDeleteLine=#delline
commandDeleteMatch=#delmatch
commandSpace=#space
commandTab=#tab

infile=%1%
refile=%2%
outfile=%3%

path=C:\Dropbox\AHKs\REFP\
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

;read in all of the regexs
i=1
Loop
{
   ;i:=A_Index
   ReplaceLineNo:=i*2
   NeedleLineNo:=ReplaceLineNo-1
   FileReadLine, Needle%i%, %refile%, %NeedleLineNo%
   if ErrorLevel
      break
   FileReadLine, Replace%i%, %refile%, %ReplaceLineNo%
   if ErrorLevel
      break
   if (Replace%i% == commandDebug OR Needle%i% == commandDebug)
      break

   if (Replace%i% = "#elimRowsThatDontMatch")
   {
      thisTempNeedle:=Needle%i%
      Needle%i% =^
      Replace%i%=ZZZ
      i++
      Needle%i% =^(ZZZ.*%thisTempNeedle%.*)$
      Replace%i%=AAA$1
      i++
      Needle%i% =^ZZZ.*$
      Replace%i%=#suppresscrlf
      i++
      Needle%i% =^AAAZZZ
      Replace%i%=
      i++
   }

   ;MsgBox, 4, , Line #%A_Index% is "%line%".  Continue?
   TotalRegExs:=i
   i++
}

;Get the temp file ready, we'll use it for processing during each loop iter
FileCopy, %infile%, %tempfile%, 1

;Process the file using each regex, one by one
Loop %TotalRegExs%
{
   i=%A_Index%
   FileMove, %outfile%, %tempFile%, 1

   ;AddToTrace(needle%i%, replace%i%)

   ;DONE;;;TODO put this into a fcn? GetTotalLinesinFile(tempFile)
   ;Loop, read, %tempfile%
      ;totalTempLines:=A_Index
   totalTempLines := FileLineCount(tempfile)

   ;process each line from the temp file
   Loop, read, %tempfile%
   {
      suppressCrlf:=false
      thisTempLineNum:=A_Index
      ;debug("line nums", thistemplinenum, totaltemplines)

      ;if we're on the last line, suppress the crlf
      if (thisTempLineNum == totalTempLines)
         suppressCrlf:=true

      thisReplace := Replace%i%
      thisNeedle := Needle%i%

      thisNeedle := StripCommands(thisNeedle)

      ;determine if this line is a match
      if NOT RegExMatch(A_LoopReadLine, thisNeedle)
         LineToPrint=%A_LoopReadLine%
      else
      {
         if InStr(thisReplace, commandDeleteLine)
            continue
         if InStr(thisReplace, commandSuppressCrlf)
            suppressCrlf:=true

         ;debug(thisReplace)
         ;debug(commandDeleteLine)

         ;strip the commands out of the needle and replace strings
         ;debug(thisneedle, thisreplace)
         thisReplace:=StripCommands(thisReplace)
         thisReplace:=StringReplace(thisReplace, commandSuppressCrlf)
         thisReplace:=StringReplace(thisReplace, commandDelMatch)
         ;debug(thisneedle, thisreplace)

         ;perform the replacement now
         LineToPrint:=RegExReplace(A_LoopReadLine, thisNeedle, thisReplace)
      }

      if NOT suppressCrlf
         LineToPrint.="`n"

      FileAppend, %LineToPrint%, %outfile%

      ;debug(i, replace%i%, thisreplace, A_LoopReadLine, Needle%i%)
   }
}

ExitApp
;end of the script

StripCommands(string)
{
   global commandSuppressCrlf
   global commandDelMatch
   global commandNewLine
   global commandTab
   global commandSpace

   string:=StringReplace(string, commandNewLine, "`n", 1)
   string:=StringReplace(string, commandTab, "`t")
   string:=StringReplace(string, commandSpace, " ")

   return string
}
