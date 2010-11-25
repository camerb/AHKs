Run, "C:\Program Files (x86)\VIA\VIAudioi\VDeck\VDeck.exe"

ForceWinFocus("VIA HD Audio Deck ahk_class #32770")

Click 194 283

Click 596 246
Click 529 264
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
