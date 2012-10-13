#include FcnLib.ahk


;109.155.196.7  <== IP address to DDOS! It's possibru!!!
#SingleInstance Force

ip := clipboard
;ip := "109.155.196.7"
ip_site := "http://whatismyipaddress.com/ip/" . ip

MsgBox, 4, , "%ip%" <== value stored in clipboard.`n`nIs this the correct IP to locate?`n`n(Press YES or NO)
IfMsgBox No
    exitapp

pwb := ComObjCreate("InternetExplorer.Application")
    pwb.Visible := false
    pwb.Navigate(ip_site) ;enter your URL here

    while pwb.ReadyState <> 4
        continue

filedelete, location.txt
loc := pwb.document.all.section_content.InnerText

;get a link for the map
pageTextMess := RemoveLineEndings(loc)
;Clipboard := pageTextMess
;url=https://maps.google.com/maps?q=32.9482,-96.7297&num=1&t=m&z=9
;AllEndings=(Lat|Lon|Geo|Area)
Decimal=. *(-?\d+\.\d+)
LatNeedle=Latitude%Decimal%
LonNeedle=Longitude%Decimal%
;LonNeedle=Lon%Decimal%%AllEndings%
RegExMatch(pageTextMess, LatNeedle, lat)
RegExMatch(pageTextMess, LonNeedle, lon)
;RegExMatch(pageTextMess, "Lat.* (-?\d+\.\d+) .*Lon", lat)
;RegExMatch(pageTextMess, "Lon.* (-?\d+\.\d+) .*(Geo|Area)", lon)
url=https://maps.google.com/maps?q=%lat1%,%lon1%&num=1&t=m&z=9
Run, %url%

msgbox % loc
fileappend, %loc%, location.txt

pwb.Quit
pwb := ""
exitapp

Esc::
pwb.Quit
pwb := ""
exitapp
return
