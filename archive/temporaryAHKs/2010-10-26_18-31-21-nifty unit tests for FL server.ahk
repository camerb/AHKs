#include FcnLib.ahk


filename=C:\DataExchange\urltempfile.txt
;UrlDownloadToVar or HttpQuery would be better here
url=http://phosphorus:3000/memberships/judge/3775?start=25&limit=25&sort=membership_type_id&dir=ASC&content-type=application/json
UrlDownloadToFile, %url%, %filename%
FileRead, playlist, %filename%

playlist:=RegExReplace(playlist, "(`r|`n)", " ")
;debug(playlist)
if InStr(playlist, "24028")
   debug("YUP, it's in there!")
else
   debug("nope, not there")

