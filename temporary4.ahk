#include FcnLib.ahk
#include C:\My Dropbox\ahk large files\usaalogin.ahk


csvfile=C:\My Dropbox\ahk large files\DailyFinancial.csv
time:=CurrentTime("hyphenated")

;Sleep, 5000
Run, "C:\Program Files\Opera\opera.exe"
ForceWinFocus("Opera")
Sleep, 1000
Send, !d
WinGetActiveTitle, oldTitle
Sleep, 100
Send, usaa.com{ENTER}

WinWaitActiveTitleChange(oldTitle)
Sleep, 9000

if ClickIfImageSearch("images/usaa/Logo.bmp")
   Sleep, 5000
else
   debug("silent log", A_ScriptName, "What on earth, we didn't even see the usaa logo")

if ForceWinFocusIfExist("Log On to usaa.com - Opera")
{
   debug("silent log", A_ScriptName, "thought this was a candidate for deletion", "saw that weird log on page")
   Send, !d
   WinGetActiveTitle, oldTitle
   Sleep, 100
   Send, usaa.com{ENTER}
   Sleep, 5000
   ForceWinFocusIfExist("Log On to usaa.com - Opera")
      fatalErrord("unable to get past alternative login screen")
   Sleep, 5000
}
if ForceWinFocusIfExist("USAA - Member Access - Opera")
{
   debug("silent log", A_ScriptName, "thought this was a candidate for deletion", "saw that weird member access page")
   Sleep, 2000
   ClickIfImageSearch("images/usaa/MemberAccessButton.bmp")
   Sleep, 5000
}


usaalogin()

SavingsBalance  := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d1209462ee637b61c599&CombinedView=TRUE")
CheckingBalance := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d12081af1bd8872ba833&CombinedView=TRUE")
CreditBalance   := GetAccountInfo("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encryptedb15eff1c50e20965cf67cf785d4589cd0a8a39aafd4160dc&CombinedView=TRUE")

WinClose

overallBalance := SavingsBalance + CheckingBalance - CreditBalance
overallBalance := StringTrimRight(overallBalance, 4)

csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, CreditBalance, overallBalance)
debug("silent log", csvline)
FileAppend, %csvline%`n, %csvfile%

Sleep, 10000
Reload

GetAccountInfo(url)
{
   ;force it to change the page, cause the title is the same for all accounts
   GoToPage("google.com")

   ;get the text of the entire page
   returned:=GhettoUrlDownloadToVar(url)

   ;find the account balance that we are looking for
   returned:=RegExReplace(returned, "(`r|`n)", " ")
   RegExMatch(returned, "<th>(Current Balance).*?(</tr>)", returned)
   RegExMatch(returned, "(\d*,*)*\d+\.\d+", returned)
   returned:=RegExReplace(returned, ",", "")
   debug("silent log from getacctinfo", "hebrew", returned)

   return returned
}

GoToPage(url)
{
   ;number to verify that the clipboard was never assigned to
   null:=Random(100000,999999)
   Clipboard:=null

   ;opera save page source
   WinGetActiveTitle, oldTitle
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   Send, !d
   Sleep, 100
   Send, %url%
   Send, {ENTER}
   Sleep, 5000
}
