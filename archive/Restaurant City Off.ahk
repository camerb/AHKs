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
Sleep, 600
Send, {CTRLDOWN}{END}{CTRLUP}
MouseClick, left,  279,  439
Sleep, 600
MouseClick, left,  14,  348
Sleep, 600
Send, {CTRLDOWN}{HOME}{CTRLUP}

WinWait, %restcitywin%, 
IfWinNotActive, %restcitywin%, , 
WinActivate, %restcitywin%, 
WinWaitActive, %restcitywin%, 

;Give each person full health
Loop 6
{
MouseClick, left,  397,  362
Sleep, 600
MouseClick, left,  587,  473
Sleep, 600
}

;Hit the checkmark
MouseClick, left,  665,  475
Sleep, 600

;KeyWait, a, D