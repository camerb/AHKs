#include FcnLib.ahk
#include C:\My Dropbox\ahk large files\usaalogin.ahk

C_VersionNum=kids
C_ShortSleep=100
C_MedSleep=2000
C_LongSleep=6000
csvfile=C:\My Dropbox\ahk large files\DailyFinancial.csv
time:=CurrentTime("hyphenated")
date:=CurrentTime("", "slashdate")

usaalogin()

GoToPage("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encryptedb15eff1c50e20965cf67cf785d4589cd0a8a39aafd4160dc&CombinedView=TRUE")

ForceWinFocus("USAA / My Accounts / Account Summary - Opera")
Sleep %C_MedSleep%
ClickIfImageSearch("images/usaa/exportTab.bmp")
Send, {TAB}{RIGHT 2}{TAB}
SendRaw, 10/10/1979
Send, {TAB 2}
SendRaw, %date%
Send, {TAB 2}
Send, {DOWN 2}

;click on export button
ClickIfImageSearch("images/usaa/GreenButton.bmp")
Sleep %C_LongSleep%
Click
Sleep %C_ShortSleep%
Click
Click
Click
Click
Click
Click
Click
Click
