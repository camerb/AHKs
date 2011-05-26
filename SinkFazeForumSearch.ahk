;#include FcnLib.ahk

;http://www.autohotkey.com/forum/viewtopic.php?p=196070#196070
;http://www.autohotkey.com/forum/viewtopic.php?p=296656#296656

/*
The purpose of this script is to provide a quick and easy way to search the forum for information.  You can use this script as a standalone utility or incorporate it into an existing script for easier use. Type in your search parameters and click "Search" to use the site's search itself, or click "Google It!" to do a custom search of the site using Google. The utility is assigned to a default hotkey(Alt+H), as are the search functions (Alt+F to search the site, Alt+G to search the site via Google).
*/

;!h::
Gui, Add, Text, x10 y10 w300 h20, Search Autohotkey's site documentation or search from Google:
Gui, Add, Edit, yp+20 wp vSearch,
Gui, Add, Button, yp+30 w77 h26 gfSearch, &Forum Search
Gui, Add, Button, xp+85 wp hp ggSearch, &Google It!
Gui, Show, AutoSize Center, Quick Search for Autohotkey
Return

fSearch:
Gui, Submit
Gui, Destroy
Run
, % "http://www.autohotkey.com/search/search.php?site=0&path=&result_page=search.php&query_string="
. RegExReplace(RegExReplace(Search,"#","`%23"),A_Space,"`%20")
. "&option=start&search=Search"
return

gSearch:
Gui, Submit
;Gui, Destroy
Run, http://www.google.com/search?q=%Search%+site:autohotkey.com
return

GuiClose:
Gui, Destroy
return

;#IfWinActive Quick Search for Autohotkey
;^r::Gosub, ButtonForumSearch
;^g::Gosub, ButtonGoogleIt!
