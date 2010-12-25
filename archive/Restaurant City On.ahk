restcitywin = Restaurant City on Facebook - Mozilla Firefox

;Run, http://apps.facebook.com/restaurantcity/

WinWait, %restcitywin%, 
IfWinNotActive, %restcitywin%, , 
WinActivate, %restcitywin%, 
WinWaitActive, %restcitywin%, 

WinMove, %restcitywin%, ,, , 1013, 765, 

;Sleep 180000

WinWait, %restcitywin%, 
IfWinNotActive, %restcitywin%, , 
WinActivate, %restcitywin%, 
WinWaitActive, %restcitywin%, 
Send {CTRLDOWN}{HOME}{CTRLUP}
;MouseClick, left,  604,  480

WinWait, %restcitywin%, 
IfWinNotActive, %restcitywin%, , 
WinActivate, %restcitywin%, 
WinWaitActive, %restcitywin%, 
MouseClick, left,  15,  218
Sleep, 800
Send, {CTRLDOWN}{END}{CTRLUP}
MouseClick, left,  279,  439
Sleep, 800
MouseClick, left,  14,  348
Sleep, 800
Send, {CTRLDOWN}{HOME}{CTRLUP}

WinWait, %restcitywin%, 
IfWinNotActive, %restcitywin%, , 
WinActivate, %restcitywin%, 
WinWaitActive, %restcitywin%, 

;Give each person a job
MouseClick, left,  458,  363
Sleep, 800
MouseClick, left,  591,  484
Sleep, 800
MouseClick, left,  536,  372
Sleep, 800
MouseClick, left,  582,  470
Sleep, 800
MouseClick, left,  584,  360
Sleep, 800
MouseClick, left,  585,  481
Sleep, 800
MouseClick, left,  578,  366
Sleep, 800
MouseClick, left,  592,  481
Sleep, 800
MouseClick, left,  531,  371
Sleep, 800
MouseClick, left,  584,  480
Sleep, 800
MouseClick, left,  520,  365
Sleep, 800
MouseClick, left,  587,  484
Sleep, 800

;Hit the checkmark
MouseClick, left,  665,  475
Sleep, 800

;KeyWait, a, D