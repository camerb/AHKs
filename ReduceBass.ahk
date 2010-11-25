Run, "C:\Program Files (x86)\VIA\VIAudioi\VDeck\VDeck.exe"

ForceWinFocus("VIA HD Audio Deck ahk_class #32770")

Click 194 283

Click 426 385
Click 385 385
Click 344 385
Click 304 385
Click 261 385
Sleep, 100

;exit
Click 748 17

ForceWinFocus(titleofwin, options="")
{
WinWait, %titleofwin%
IfWinNotActive, %titleofwin%
WinActivate, %titleofwin%
WinWaitActive, %titleofwin%
}
