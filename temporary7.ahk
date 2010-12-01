#include FcnLib.ahk


joe:=GhettoUrlDownloadToVar("https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=encrypted10bb142d9db5d1209462ee637b61c599&CombinedView=TRUE")

GhettoUrlDownloadToVar(url)
{
   ;opera save page source
   WinGetActiveTitle, oldTitle
   ForceWinFocus("ahk_class (OperaWindowClass|OpWindow)", "RegEx")
   Send, !d
   Sleep, 100
   Send, %url%
   Send, {ENTER}

   ;loop until the window title changes
   Loop
   {
      WinGetActiveTitle, newTitle
      if (oldTitle != newTitle)
         break
      Sleep, 100
   }
   Send, {CTRLDOWN}uacw{CTRLUP}
   return Clipboard
}
