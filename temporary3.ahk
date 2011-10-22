#include FcnLib.ahk

;FTP with CURL!!!
joe := SexPanther()
thisFile=C:\Dropbox\AHKs\temporary4.ahk
cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFile%" --user camerb:%joe% ftp.autohotkey.net
;cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFile%" --user camerb:%joe% ftp.autohotkey.net/folder
ret:=CmdRet_RunReturn(cmd)
debug(ret)
