Run, "C:\Program Files\Mozilla Thunderbird\thunderbird.exe"
Run, C:\SoftDev\VS2008EE\Projects\WeeklyReports\WeeklyReports\bin\Debug\WeeklyReports.exe

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
WinWait, Compose: (no subject), 
IfWinNotActive, Compose: (no subject), , WinActivate, Compose: (no subject), 
WinWaitActive, Compose: (no subject),
MouseClick, left,  237,  222
Sleep, 100
Send, Reminder: RMCI Weekly Reports

;Type message
WinWait, Compose: Reminder: RMCI Weekly Reports, 
IfWinNotActive, Compose: Reminder: RMCI Weekly Reports, , WinActivate, Compose: Reminder: RMCI Weekly Reports, 
WinWaitActive, Compose: Reminder: RMCI Weekly Reports, 
Sleep, 105
MouseClick, left,  98,  342
Sleep, 105
Loop, read, C:\DataExchange\WeeklyReports\workingDir\weeklyreport.dat
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
        Send, %A_LoopField%
    }
}
Sleep, 105

;Send the email
Send, {CTRLDOWN}{ENTER}{CTRLUP}
Sleep, 105

WinClose, Inbox - Thunderbird, 
WinClose, rmci email addresses - Notepad, 

WinMinimize, Compose: Reminder: RMCI Weekly Reports, 