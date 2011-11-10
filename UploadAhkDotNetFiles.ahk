#include FcnLib.ahk

;FTP with CURL!!!
localPath=C:\Dropbox\Public\camerb-ahk-net\
remotePath=ftp://ftp.autohotkey.net/
timestamp := Currenttime("hyphenated")
joe := SexPanther()
thisFile=C:\Dropbox\AHKs\temporary5.ahk

;stuff that I did initially while experimenting
;strategy: create the folder, then put the file in
;cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFile%" --user camerb:%joe% ftp.autohotkey.net
;cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFile%" --user camerb:%joe% ftp://ftp.autohotkey.net/folder/%timestamp%.ahk
;cmd=C:\Dropbox\Programs\curl\curl.exe --ftp-create-dirs --user camerb:%joe% ftp://ftp.autohotkey.net/%timestamp%/
;cmd=C:\Dropbox\Programs\curl\curl.exe --ftp-create-dirs --user camerb:%joe% ftp://ftp.autohotkey.net/joe/jane/
;ret:=CmdRet_RunReturn(cmd)
;debug(ret)
;cmd=C:\Dropbox\Programs\curl\curl.exe --ftp-create-dirs --user camerb:%joe% ftp://ftp.autohotkey.net/%timestamp%/
;ret:=CmdRet_RunReturn(cmd)

;trying to debug issues
;thisFilePath=C:\Dropbox\Public\camerb-ahk-net\index.html
;relativePath=index.html
;thisFilePath=C:\Dropbox\AHKs\temporary4.ahk
;relativePath=temporary4.ahk
;cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFilePath%" --user camerb:%joe% "ftp://ftp.autohotkey.net/%relativePath%"
;ret:=CmdRet_RunReturn(cmd)
;debug("errord nolog", ret)
;ExitApp

;look through all files
Loop, %localPath%*, 0, 1
{
   thisFilePath := A_LoopFileFullPath
   ;thisFile := A_LoopFile

   ;stripping the local path out of the string
   literalSearch=^\Q%localPath%\E
   relativePath := RegExReplace(thisFilePath, literalSearch)
   relativePath := StringReplace(relativePath, "\", "/")

   RegExMatch(relativePath, "^.*/", folderPath)
   cmd=C:\Dropbox\Programs\curl\curl.exe --ftp-create-dirs --user camerb:%joe% "ftp://ftp.autohotkey.net/%folderPath%"
   if folderPath
      ret:=CmdRet_RunReturn(cmd)

   cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFilePath%" --user camerb:%joe% "ftp://ftp.autohotkey.net/%relativePath%"
   ret:=CmdRet_RunReturn(cmd)

   msg.=relativePath . "`n"
}
debug("errord nolog", msg)
;debug("done")
