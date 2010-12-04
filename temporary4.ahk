#include FcnLib.ahk
#include C:\My Dropbox\ahk large files\usaalogin.ahk

C_VersionNum=kids
C_ShortSleep=100
C_MedSleep=2000
C_LongSleep=6000
csvfile=C:\My Dropbox\ahk large files\DailyFinancial.csv
time:=CurrentTime("hyphenated")

;Sleep, %C_LongSleep%
Run, "C:\Program Files\Opera\opera.exe"
ForceWinFocus("Opera")
Sleep, %C_MedSleep%
Send, !d
WinGetActiveTitle, oldTitle
Sleep, 100
Send, usaa.com{ENTER}

WinWaitActiveTitleChange(oldTitle)
Sleep, %C_LongSleep%

if ClickIfImageSearch("images/usaa/Logo.bmp")
   Sleep, %C_LongSleep%
else
   debug("silent log", A_ScriptName, "What on earth, we didn't even see the usaa logo")

;Loop 5
;{
;if ForceWinFocusIfExist("")
;}

if ForceWinFocusIfExist("Log On to usaa.com - Opera")
{
   debug("silent log", A_ScriptName, "thought this was a candidate for deletion", "saw that weird log on page")
   Send, !d
   WinGetActiveTitle, oldTitle
   Sleep, 100
   Send, usaa.com{ENTER}
   Sleep, %C_LongSleep%
   if ForceWinFocusIfExist("Log On to usaa.com - Opera")
      die("unable to get past alternative login screen", A_ScriptName, A_LineNumber, A_ThisFunc)
   Sleep, %C_LongSleep%
}
if ForceWinFocusIfExist("USAA - Member Access - Opera")
{
   ;not a candidate for deletion
   ;debug("silent log", A_ScriptName, "thought this was a candidate for deletion", "saw that weird member access page")
   Sleep, %C_MedSleep%
   ClickIfImageSearch("images/usaa/MemberAccessButton.bmp")
   Sleep, %C_LongSleep%
}


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
   returned:=GhettoUrlDownloadToVar(url)

   ;find the account balance that we are looking for
   returned:=RegExReplace(returned, "(`r|`n)", " ")
   RegExMatch(returned, "<th>(Current Balance).*?(</tr>)", returned)
   RegExMatch(returned, "(\d*,*)*\d+\.\d+", returned)
   returned:=RegExReplace(returned, ",", "")
   debug("silent log from getacctinfo", C_VersionNum, returned)

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
   Sleep, %C_LongSleep%
}

die(errorMsg, ScriptName="", LineNumber="", ThisFunc="")
{
   sendEmail(errorMsg, securityQuestionPage, "", "cameronbaustian+financebot@gmail.com")
   fatalErrord("red line", ScriptName, LineNumber, ThisFunc, errorMsg)
}

;some sites require a /real/ login, so we aren't able to do a
;   simple request. Instead we should use a browser, view source,
;   and copy the source to the clipboard.
;TODO maybe have a browser param to choose which browser you
;   want to use to request the page.
;FIXME doesn't work quite right yet. Sometimes it doesn't copy
GhettoUrlDownloadToVar(url)
{
   global C_VersionNum
   global C_ShortSleep
   global C_MedSleep
   global C_LongSleep
   ;number to verify that the clipboard was never assigned to
   null:=Random(100000,999999)
   Clipboard:=null

   ;opera save page source
   WinGetActiveTitle, oldTitle
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   Send, !d
   Sleep, %C_ShortSleep%
   Send, %url%
   Send, {ENTER}
   Sleep, %C_ShortSleep%

   WinWaitActiveTitleChange(oldTitle)
   Sleep, %C_ShortSleep%

   ;Send, {CTRLDOWN}uacw{CTRLUP}

   ;press the button to launch the new window. but sometimes it doesn't pick it up
   count=0
   Loop
   {
      count++
      if ForceWinFocusIfExist("Source", "Contains")
      {
         if (count != 2)
            debug("silent log green line", "found source page after # of tries:", count)
         break
      }
      Send, ^u
      Sleep, %C_ShortSleep%
   }
   Sleep, %C_ShortSleep%
   Send, ^a
   Send, ^a
   Send, ^a
   Send, ^a
   Sleep, %C_ShortSleep%
   Send, ^c
   Send, ^c
   Send, ^c
   Send, ^c
   ;ClipWait, 2
   ;debug("silent log", "just copied to clipboard")
   count=0
   Loop
   {
      count++
      if (Clipboard != null)
      {
         if (count != 1)
            debug("silent log yellow line", "clipboard is no longer null after # of tries:", count)
         break
      }
      Sleep, %C_ShortSleep%
   }
   Sleep, %C_ShortSleep%
   Send, ^w
   Sleep, %C_LongSleep%

   if (Clipboard == null)
   {
      debug("silent log", "candidate for deletion", "the clipboard should")
      ;errord("silent", "clipboard never got any new contents")
      ;die("unable to get past alternative login screen", A_ScriptName, A_LineNumber, A_ThisFunc)
      return "empty"
   }

   return Clipboard
}

;TODO I think this is a candidate to move into FcnLib
;Wait until the title of the active window changes (note that changing to another window sets it off, too)
WinWaitActiveTitleChange(oldTitle="")
{
   ;if they didn't give a title, try to grab the title as quickly as possible
   ;this is less reliable, but if we don't have the title, we'll just do the best we can
   if (oldTitle == "")
      WinGetActiveTitle, oldTitle
   ;loop until the window title changes
   Loop
   {
      WinGetActiveTitle, newTitle
      if (oldTitle != newTitle)
         break
      Sleep, 100
   }
}
