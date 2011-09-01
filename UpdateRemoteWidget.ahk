#include FcnLib.ahk
#NoTrayIcon

file=C:\Dropbox\Public\remotewidget.txt
csv=C:\Dropbox\Public\temps.csv

time:=CurrentTime("hyphenated")

var:=UrlDownloadToVar("http://www.weather.com/weather/today/Garland+TX+75042")
RegExMatch(var, "realTemp.{10}", var)
RegExMatch(var, "\d+", var)
rand:=Random(100, 999)
FileDelete, %file%
FileAppend, Current Temp is: %var%`n, %file%
;FileAppend, Rand: %rand%`n, %file%
FileAppend, %time%`n, %file%

;output the temp and time (cause data is awesome)
FileAppend, %time%`,%var%`n, %csv%
