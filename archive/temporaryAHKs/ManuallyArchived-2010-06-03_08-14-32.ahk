;WinWait, Bookmark Manager - Google Chrome,
;IfWinNotActive, Bookmark Manager - Google Chrome, , WinActivate, Bookmark Manager - Google Chrome,
;WinWaitActive, Bookmark Manager - Google Chrome,
;MouseClick, left,  251,  20
;Sleep, 100
;MouseClick, left,  180,  189
;Sleep, 100
;MouseClick, left,  199,  477
;Sleep, 100
;WinWait, Save As,
;IfWinNotActive, Save As, , WinActivate, Save As,
;WinWaitActive, Save As,
;MouseClick, left,  129,  23
;Sleep, 100
;MouseClick, left,  190,  18
;MouseClick, left,  190,  18
;Sleep, 100

Run, SaveChromeBookmarks.ahk
