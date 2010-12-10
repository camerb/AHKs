#include FcnLib.ahk
#include C:\My Dropbox\ahk large files\usaalogin.ahk

C_VersionNum=kids
C_ShortSleep=100
C_MedSleep=2000
C_LongSleep=6000
csvfile=C:\My Dropbox\ahk large files\DailyFinancial.csv
time:=CurrentTime("hyphenated")

usaalogin()

SavingsBalance  := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d1209462ee637b61c599&CombinedView=TRUE")
CheckingBalance := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d12081af1bd8872ba833&CombinedView=TRUE")
CreditBalance   := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encryptedb15eff1c50e20965cf67cf785d4589cd0a8a39aafd4160dc&CombinedView=TRUE")

WinClose

overallBalance := SavingsBalance + CheckingBalance - CreditBalance
overallBalance := StringTrimRight(overallBalance, 4)

csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, CreditBalance, overallBalance)
debug("silent log grey line", csvline)
FileAppend, %csvline%`n, %csvfile%

if (SavingsBalance=="" and CheckingBalance=="" and CreditBalance=="")
   die("login attempt completely unsuccessful", A_ScriptName, A_LineNumber, A_ThisFunc)

Sleep, %C_LongSleep%
Reload

GetAccountInfo(url)
{
   global C_VersionNum
   global C_ShortSleep
   global C_MedSleep
   global C_LongSleep
   ;force it to change the page, cause the title is the same for all accounts
   GoToPage("http://dl.dropbox.com/u/789954/remotewidget.txt")
   Sleep, %C_LongSleep%

   ;get the text of the entire page
   ;debug(url)
   returned:=GhettoUrlDownloadToVar(url)

   ;find the account balance that we are looking for
   returned:=RegExReplace(returned, "(`r|`n)", " ")
   RegExMatch(returned, "<th>(Current Balance).*?(</tr>)", returned)
   RegExMatch(returned, "(\d*,*)*\d+\.\d+", returned)
   returned:=RegExReplace(returned, ",", "")
   debug("silent log from getacctinfo", C_VersionNum, returned)

   return returned
}
