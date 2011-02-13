#include FcnLib.ahk


      codefile:=urlDownloadToVar("http://sites.google.com/site/ahkcoedz/remoteahk")


   codefile:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
   RegExMatch(codefile, "sites-layout-name-one-column.*?tbody...table", codefile)
   codefile:=RegExReplace(codefile, "ZZZnewlineZZZ", "`n`n`n")

   ;get rid of some of the html
   codefile:=RegExReplace(codefile, "\<div.*?\>", "`n")
   codefile:=RegExReplace(codefile, "\<.*?\>", "")
   codefile:=RegExReplace(codefile, "^.*?\>", "")
   codefile:=RegExReplace(codefile, "\<.*?$", "")
   codefile:=StringReplace(codefile, chr(194), "", "All")
   codefile:=StringReplace(codefile, chr(160), "", "All")

   ;odd that this shows up (they put it in multiple spots)
   codefile:=RegExReplace(codefile, "remoteahk\n", "")

   ;translate from html to regular
   codefile:=RegExReplace(codefile, "&lt;", "<")
   codefile:=RegExReplace(codefile, "&gt;", ">")

   ;codefile:=StringReplace(codefile, chr(194), "", "All")
   ;last:=StringReplace(last, chr(194), "", "All")

   codefile:=RegExReplace(codefile, "(`r|`n|`r`n)", "`n")
   last:=RegExReplace(last, "(`r|`n|`r`n)", "`n")
   codefile:=RegExReplace(codefile, "`n+", "`n")
   errord("nolog", codefile)

