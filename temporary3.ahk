#include FcnLib.ahk

;FTP with CURL!!!
timestamp := Currenttime("hyphenated")
joe := SexPanther()
thisFile=C:\Dropbox\AHKs\temporary5.ahk
;cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFile%" --user camerb:%joe% ftp.autohotkey.net
cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFile%" --user camerb:%joe% ftp://ftp.autohotkey.net/folder/%timestamp%.ahk
cmd=C:\Dropbox\Programs\curl\curl.exe --ftp-create-dirs --user camerb:%joe% ftp://ftp.autohotkey.net/folder/%timestamp%.ahk
ret:=CmdRet_RunReturn(cmd)
debug(ret)
