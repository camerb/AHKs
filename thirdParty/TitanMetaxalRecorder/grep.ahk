/*
	Title: Global Regular Expression Match
		Find all matches of a regex in a string.
	
	------------------------------------------------------------
	
	Function: grep
		Sets the output variable to all the entire or specified subpattern matches and returns their offsets within the haystack.
	
	Parameters:
		h - haystack
		n - regex
		v - output variable (ByRef)
		s - (optional) starting position (default: 1)
		e - (optional) subpattern to save in the output variable, where 0 is the entire match (default: 0)
		d - (optional) delimiter - the character that seperates multiple values (default: EOT (0x04))
	
	Returns:
		The position (or offset) of each entire match.
	
	Remarks:
		Since multiple values are seperated with the delimiter any found within the haystack will be removed.
	
	------------------------------------------------------------
	
	Function: grepcsv
		Similar to the grep function but returned offsets and all matches including their subpatterns are given in CSV format.
	
	Parameters:
		h - haystack
		n - regex
		v - output variable (ByRef)
		s - (optional) starting position (default: 1)
	
	Returns:
		The position (or offset) of each entire match.
	
	Remarks:
		All fields in the output variable and returned value are delimited by double-quote characters.
	
	------------------------------------------------------------
	
	About: License
		- Version 2.0 by Titan <http://www.autohotkey.net/~Titan/#regexmatchall>.
		- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>
	
*/

grep(h, n, ByRef v, s = 1, e = 0, d = "") {
	v =
	StringReplace, h, h, %d%, , All
	Loop
		If s := RegExMatch(h, n, c, s)
			p .= d . s, s += StrLen(c), v .= d . (e ? c%e% : c)
		Else Return, SubStr(p, 2), v := SubStr(v, 2)
}

grepcsv(h, n, ByRef v, s = 1) {
	v =
	x = 0
	xp = 1
	Loop {
		If xp := InStr(n, "(", "", xp)
			x += SubStr(n, xp + 1, 1) != "?", xp++
		Else {
			Loop
				If s := RegExMatch(h, n, c, s) {
					p = %p%`n"%s%"
					s += StrLen(c)
					StringReplace, c, c, ", "", All
					v = %v%`n"%c%"
					Loop, %x% {
						StringReplace, cx, c%A_Index%, ", "", All
						v = %v%,"%cx%"
					}
				} Else Return, SubStr(p, 2), v := SubStr(v, 2)
		}
	}
}
