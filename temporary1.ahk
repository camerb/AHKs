#include FcnLib.ahk


h=
(
Chambu
3 6
-21  0.000063
0  12.3889  0.53023E-02
0  0  0
0  12.92489  0.47573
0  0  0
0  20.14849  0.47573
Extraction Flow
 7 3
 -5  0.000125
 0  20.14849  0.82262
 0  19.54473  0.82262
Mambue
 5 2
 20.14849  0.47573  0.82262  1.22402  0.57484  1.22402
 15  0.00013
Scroll
 8  2
 244  25.06  244  0.00025
 0  0
Extraction Flow
 7 3
 -5  0.000125
 0  20.14849  0.82262
 0  19.54473  0.82262
pappu
 7 3
 -5  0.000125
 0  20.14849  0.82262
 0  19.54473  0.82262
)

word=scroll
needle=i)(%word%[\d\.-\sE]+)

; get everything after the specified word. until the next word appears.
regexmatch(h, needle, out)

; since we added an E into the exceptions, it may steal the first E off of a different section.
; this removes that single E (capital E only)
out1:=regexreplace(out1, "\bE\s*\b")

; now we delete that stuff that was found above with regexreplace. and then append it below everything.
booya:=regexreplace(h, needle) "`n-----`n" out1

; since we removed any E, this word is afftected. but this like repairs it.
booya:=regexreplace(booya, "\b(xtraction\s*)\b", "E$1")
msgbox %booya%
exitapp
