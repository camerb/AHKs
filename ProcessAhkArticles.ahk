#include FcnLib.ahk

;TODO make this work so that the files are stuffed into a template for formatting
;TODO make a central index file that keeps track of filename, title, subtitle
;TODO process the rest using REFP
Loop, C:\Dropbox\Public\camerb-ahk-net\raw-articles\*
{
   thisFile := A_LoopFileFullPath

   thisShortFile := A_LoopFileName
   thisShortFile := StringTrimRight(thisShortFile, 4)
   destHtml=C:\Dropbox\Public\camerb-ahk-net\%thisShortFile%.html
   ;debug(destHtml, thisfile)

   thisTitle := FileReadLine(thisFile, 1)
   thisSubTitle := FileReadLine(thisFile, 2)

   ;TODO process list items, save them to the index
   listItem=`n<li><a href="%thisShortFile%.html">%thisTitle% - %thisSubTitle%</a></li>

   index=0
   Loop, read, %thisFile%
   {
      index++
      thisLine := A_LoopReadLine

      if (index <= 2)
         continue

      ;debug(thisLine)

      if (mod(index, 3) == 0)
         continue
      if (mod(index, 3) == 1)
      {
         addition=`n<h2>%thisLine%</h2>
         articleText .= addition
      }
      if (mod(index, 3) == 2)
      {
         addition=`n<p>`n%thisLine%`n</p>
         articleText .= addition
      }

      ;debug(articleText)
   }

   modifiedDate:=FileGetTime(thisFile)
   prettyDate:=FormatTime(modifiedDate, "wordsdate")

   header=<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">`n<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252">`n`n<meta name="description" content="Camerb's AHK site - %thisTitle%">`n<title>Camerb's AHK site - %thisTitle%</title>`n<link href="default.css" rel="stylesheet" type="text/css" media="all">`n</head>`n<body>`n`n<center>`n<table width="700px"><tr><td>`n`n<h1>%thisTitle%</h1>`n`n<p>%thisSubtitle%</p>`n<a href="index.html">Back to the home page</a>`n
   footer=`n`n<br>`n<hr>`n<p><i>Last updated: %prettyDate%</i></p>`n`n</td>`n</tr>`n</table>`n</center>`n`n</body></html>

   wholeFile=%header%%articleText%%footer%
   FileCreate(wholeFile, destHtml)
}
ExitApp

Esc::ExitApp
