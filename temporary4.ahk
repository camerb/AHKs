#include FcnLib.ahk

DeleteTraceFile()

while true
{
   CheckTheCloud()
   SleepSeconds(15)
}

`:: ExitApp

examineStrs(str1, str2)
{
   debug(strlen(str1), strlen(str2))

   chars := strlen(str2)
   loop %chars%
   {
      char1:=substr(str1, A_Index, 1)
      char2:=substr(str2, A_Index, 1)
      equal:= substr(str1, A_Index, 1) == substr(str2, A_Index, 1)
      AddToTrace(char1, char2, equal, asc(char1), asc(char2) )

      ;debug( substr(str1, A_Index, 1), substr(str2, A_Index, 1) )
   }
}

checkTheCloud()
{
   joe:=starttimer()
   ;if (A_ComputerName="PHOSPHORUS")
   {
      last:=urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhk.txt")
      originalReq:=last
      ;FileRead, last, C:\My Dropbox\Public\latestCloudAhk.txt
      codefile:=urlDownloadToVar("http://sites.google.com/site/ahkcoedz/remoteahk")

      FileDelete, C:\request.txt
      FileAppend, %codefile%, C:\request.txt

      ;give us just the section that we want
      codefile:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
      RegExMatch(codefile, "sites-layout-name-one-column.*?tbody...table", codefile)
      codefile:=RegExReplace(codefile, "ZZZnewlineZZZ", "`n")

      ;get rid of some of the html
      codefile:=RegExReplace(codefile, "\<div\>", "`n")
      codefile:=RegExReplace(codefile, "\<.*?\>", "")
      codefile:=RegExReplace(codefile, "^.*?\>", "")
      codefile:=RegExReplace(codefile, "\<.*?$", "")

      ;odd that this shows up
      codefile:=RegExReplace(codefile, "remoteahk\n", "")

      ;codefile:=StringReplace(codefile, chr(194), "", "All")
      ;last:=StringReplace(last, chr(194), "", "All")

      codefile:=RegExReplace(codefile, "(`r|`n|`r`n)", "`n")
      last:=RegExReplace(last, "(`r|`n|`r`n)", "`n")
      ;debug(codefile, "zzz", last)

      ;msgbox % codefile
      ;msgbox % last
      FileDelete, C:\codeout.txt
      FileDelete, C:\lastout.txt
      FileAppend, %codefile%, C:\codeout.txt
      FileAppend, %last%, C:\lastout.txt

      stripExpr:="[^!@#$%^&*(){}a-zA-Z0-9 \r\n]"
      stripExpr:="\n+"
      replExpr:="`n"
      codefilestripped:=RegExReplace(codefile, stripExpr, replExpr)
      lastfilestripped:=RegExReplace(last, stripExpr, replExpr)

      if (codefilestripped != lastfilestripped)
      {
         delog("new version detected... going to run it")
         examineStrs(codefilestripped, lastfilestripped)
         FileDelete, C:\My Dropbox\Public\latestCloudAhk.txt
         FileAppend, %codefile%, C:\My Dropbox\Public\latestCloudAhk.txt
         timestamp := CurrentTime()
         FileAppend, %codefile%, C:\My Dropbox\AHKs\scheduled\phosphorus\%timestamp%.ahk

         ;need to sleep and let dropbox load the new version of the file to the server
         ;TODO 20 s was not enough (sheesh)... should we ping the hell out of it to see if it has changed?
         while (originalReq == urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhk.txt"))
            SleepSeconds(5)
      }

      ;TODO need a fcn that gives local dropbox folder location and remote dropbox folder location
   }
   AddToTrace(elapsedtime(joe))
}

AddToTrace(var, t1="", t2="", t3="", t4="", t5="", t6="", t7="", t8="", t9="", t10="", t11="", t12="", t13="", t14="", t15="")
{
   Loop 15
      var .= " " . t%A_Index%
   FileAppendLine(var, "C:\My Dropbox\Public\trace.txt")
}

DeleteTraceFile()
{
   FileDelete("C:\My Dropbox\Public\trace.txt")
}

FileAppend(text, file)
{
   EnsureDirExists(file)
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
   if NOT FileExist(source)
      fatalErrord("file doesn't exist")
   EnsureDirExists(dest)

   FileCopy, %source%, %dest%, %overwrite%
}

FileDelete(file)
{
   ;should we even bother returning an error if the file is already gone? i think not... maybe TODO log it
   if NOT FileExist(file)
      return

   FileDelete, %file%
}

FileMove(source, dest, options="")
{
   if InStr(options, "overwrite")
      overwrite=1
   if NOT FileExist(source)
      fatalErrord("file doesn't exist")
   EnsureDirExists(dest)

   FileCopy, %source%, %dest%, %overwrite%
}

