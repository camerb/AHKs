#include FcnLib.ahk

while true
{
   CheckTheCloud()
   SleepSeconds(15)
}

ESC:: ExitApp

examineStrs(str1, str2)
{
   debug(strlen(str1), strlen(str2))

   chars := strlen(str2)
   loop %chars%
   {
      char1:=substr(str1, A_Index, 1)
      char2:=substr(str2, A_Index, 1)
      equal:= substr(str1, A_Index, 1) == substr(str2, A_Index, 1)
      debug("silent log", char1, char2, equal, asc(char1), asc(char2) )

      ;debug( substr(str1, A_Index, 1), substr(str2, A_Index, 1) )
   }
}

checkTheCloud()
{
   joe:=starttimer()
   ;if (A_ComputerName="PHOSPHORUS")
   {
      last:=urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhk.txt")
      ;FileRead, last, C:\My Dropbox\Public\latestCloudAhk.txt
      codefile:=urlDownloadToVar("http://sites.google.com/site/ahkcoedz/remoteahk")

      codefile:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
      RegExMatch(codefile, "sites-layout-name-one-column.*tbody...table", codefile)
      ;<table xmlns="http://www.w3.org/1999/xhtml" cellspacing="0" class="sites-layout-name-one-column sites-layout-hbox"><tbody><tr><td class="sites-layout-tile sites-tile-name-content-1"><div dir="ltr"><div>#include FcnLib.ahk</div><div><br /></div><div>debug("silent log", "ran code from google sites remoteahk page")</div></div></td></tr></tbody></table>

      codefile:=RegExReplace(codefile, "\<div\>", "`n")
      codefile:=RegExReplace(codefile, "\<.*?\>", "")
      codefile:=RegExReplace(codefile, "^.*?\>", "")
      codefile:=RegExReplace(codefile, "\<.*?$", "")

      codefile:=RegExReplace(codefile, "(`r|`n|`r`n)", "`n")
      last:=RegExReplace(last, "(`r|`n|`r`n)", "`n")

      ;msgbox % codefile
      ;msgbox % last
      FileDelete, C:\codeout.txt
      FileDelete, C:\lastout.txt
      FileAppend, %codefile%, C:\codeout.txt
      FileAppend, %last%, C:\lastout.txt

      stripExpr:="[^a-zA-Z0-9 \n]"
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
         SleepSeconds(20)
      }

      ;TODO need a fcn that gives local dropbox folder location and remote dropbox folder location
   }
   AddToTrace(elapsedtime(joe))
}

AddToTrace(var)
{

}

DeleteTraceFile()
{

}
