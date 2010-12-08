#include FcnLib.ahk

;paste to show #ahk that UrlDownloadToVar() does not download the entire file

url:="http://dl.dropbox.com/u/789954/remotewidget.txt"
msg:=urldownloadtovar(url)
msgbox % msg
;debug(msg)

file=c:\temp.txt
urldownloadtofile, %url%, %file%
fileread, msg, %file%

msgbox % msg
;debug(msg)
