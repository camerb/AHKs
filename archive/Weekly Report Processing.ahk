Run, "C:\Program Files\Mozilla Thunderbird\thunderbird.exe"
Run, C:\SoftDev\VS2008EE\Projects\WeeklyReports\WeeklyReports\bin\Debug\WeeklyReports.exe
;WinWait, Weekly Reports Processing, 
;IfWinNotActive, Weekly Reports Processing, , WinActivate, Weekly Reports Processing, 
;WinWaitActive, Weekly Reports Processing, 

WinWait, Inbox - Thunderbird, 
IfWinNotActive, Inbox - Thunderbird, , WinActivate, Inbox - Thunderbird, 
WinWaitActive, Inbox - Thunderbird, 
;WinMaximize, Inbox - Thunderbird, 
Send, {CTRLDOWN}n{CTRLUP}

;Type the recipients
WinWait, Compose: (no subject), 
IfWinNotActive, Compose: (no subject), , WinActivate, Compose: (no subject), 
WinWaitActive, Compose: (no subject), 
WinMaximize, Compose: (no subject), 
Sleep, 100
Loop, read, C:\Users\VMEP\Documents\rmci email addresses.txt
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        Send, %A_LoopField%
    }
}

;Type the subject line
MouseClick, left,  237,  222
Sleep, 100
Send, RMCI Weekly Reports

;Type message
WinWait, Compose: RMCI Weekly Reports, 
IfWinNotActive, Compose: RMCI Weekly Reports, , WinActivate, Compose: RMCI Weekly Reports, 
WinWaitActive, Compose: RMCI Weekly Reports, 
Sleep, 100
MouseClick, left,  98,  342
Sleep, 100
Send, Typed message
Sleep, 100

;Send the email
Send, {CTRLDOWN}{ENTER}{CTRLUP}
Sleep, 100

;Close the other windows
WinClose, Inbox - Thunderbird, 
WinClose, rmci email addresses - Notepad, 

;Minimize the message window (it will close when the message is sent)
WinMinimize, Compose: RMCI Weekly Reports, 