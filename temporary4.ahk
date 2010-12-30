#include FcnLib.ahk

codefile:=urlDownloadToVar("http://sites.google.com/site/ahkcoedz/remoteahk")

codefile:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
RegExMatch(codefile, "sites-layout-name-one-column.*tbody...table", codefile)
;<table xmlns="http://www.w3.org/1999/xhtml" cellspacing="0" class="sites-layout-name-one-column sites-layout-hbox"><tbody><tr><td class="sites-layout-tile sites-tile-name-content-1"><div dir="ltr"><div>#include FcnLib.ahk</div><div><br /></div><div>debug("silent log", "ran code from google sites remoteahk page")</div></div></td></tr></tbody></table>

;this isn't even necessary
;codefile:=RegExReplace(codefile, "ZZZnewlineZZZ", "")

codefile:=RegExReplace(codefile, "\<div\>", "`n")
codefile:=RegExReplace(codefile, "\<.*?\>", "")
codefile:=RegExReplace(codefile, "^.*?\>", "")
codefile:=RegExReplace(codefile, "\<.*?$", "")
;codefile:=RegExReplace(codefile, "(Now Playing|What`'s Played Recently)", "")
;codefile:=RegExReplace(codefile, "<.*?>", "")
;codefile:=RegExReplace(codefile, " +", " ")

debug("", codefile)
