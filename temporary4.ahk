#include FcnLib.ahk
#include C:\My Dropbox\ahk large files\usaalogin.ahk

csvfile=C:\My Dropbox\ahk large files\DailyFinancial.csv
time:=CurrentTime("hyphenated")

;Sleep, 5000
;Run, "C:\Program Files\Opera\opera.exe"
ForceWinFocus("Opera")
Sleep, 1000
Send, !d
WinGetActiveTitle, oldTitle
Sleep, 100
Send, usaa.com{ENTER}

WinWaitActiveTitleChange(oldTitle)
IfWinActive, USAA - Member Access - Opera
{
   Sleep, 2000
   ClickIfImageSearch("images/usaa/MemberAccessButton.bmp")
}

usaalogin()

SavingsBalance:=GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d1209462ee637b61c599&CombinedView=TRUE")
CheckingBalance:=GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d12081af1bd8872ba833&CombinedView=TRUE")
CreditBalance:=GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encryptedb15eff1c50e20965cf67cf785d4589cd0a8a39aafd4160dc&CombinedView=TRUE")

WinClose

overallBalance := SavingsBalance + CheckingBalance - CreditBalance
overallBalance := StringTrimRight(overallBalance, 4)

csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, CreditBalance, overallBalance)
debug("silent log", csvline)
FileAppend, %csvline%`n, %csvfile%

GetAccountInfo(url)
{
   ;ForceWinFocus("USAA / My USAA - Opera")
   Sleep, 10000
   returned:=GhettoUrlDownloadToVar(url)
   ;debug(returned)

   returned:=RegExReplace(returned, "(`r|`n)", " ")
   RegExMatch(returned, "<th>(Current Balance).*?(</tr>)", returned)
   RegExMatch(returned, "(\d*,*)*\d+\.\d+", returned)
   returned:=RegExReplace(returned, ",", "")

   ForceWinFocus("USAA / My Accounts / Account Summary - Opera")
   Sleep, 1000
   Send, {BACKSPACE 16}

   ;debug(returned)
   return returned
}
