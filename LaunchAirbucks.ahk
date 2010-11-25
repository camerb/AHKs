Run, "C:\Program Files (x86)\DOSBox-0.73\dosbox.exe"
Sleep 3000
text=mount a "C:\Users\Baustian\Documents\My Dropbox\Programs\AIRBUCKS"
Send, %text%
Sleep 100
Send, {ENTER}
Sleep 100
Send, a:
Sleep 100
Send, {ENTER}
Send, airbuc12
Sleep 100
Send, {ENTER}

Loop 30
   Send, ^{F12}