#include FcnLib.ahk

;Loop
;{
;ClickIfImageSearch("images/lastfm/SaveButton.bmp", "Mouse")
;Sleep, 200
;}

var:=UrlDownloadToVar("http://www.weather.com/weather/today/Garland+TX+75042")

RegExMatch(var, "realTemp.{10}", var)
RegExMatch(var, "\d+", var)
;. .(\d{1-3}).,", outputVar)
debug(var)
