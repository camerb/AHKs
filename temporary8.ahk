#include FcnLib.ahk

thisFilePath=template.ahk

joe := SexPanther("lynx-ftp-ahk")
timestamp := Currenttime("hyphenated")

cmd=C:\Dropbox\Programs\curl\curl.exe --upload-file "%thisFilePath%" --user AHK:%joe% ftp://lynx.mitsi.com/update_logs/%timestamp%-test.txt
ret:=CmdRet_RunReturn(cmd)
debug(ret)
