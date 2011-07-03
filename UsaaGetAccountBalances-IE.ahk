#include FcnLib.ahk
#include thirdParty/COM.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk

;Awesome use of COM to log in to usaa

ini=C:\My Dropbox\AHKs\gitExempt\financial.ini
csvfile=C:\My Dropbox\AHKs\gitExempt\DailyFinancial.csv
time:=CurrentTime("hyphenated")

RunIECOM()

while NOT NetWorth
{
   GoToPageCOM("https://wwws.mint.com/login.event")
   COM_Invoke(pwb, "document.all.form-login-username.value", "cameronbaustian@gmail.com")
   COM_Invoke(pwb, "document.all.form-login-password.value", SexPanther())
   COM_Invoke(item308:=COM_Invoke(all2:=COM_Invoke(document:=COM_Invoke(pwb,"Document"),"All"),"Item",308),"click")
   WaitIEReady()

   page:=GetPageSource("https://wwws.mint.com/overview.event")

   page:=RegExReplace(page, "(`r|`n)", " ")
   RegExMatch(page, "<li class..net-worth.><span class..balance.>..(\d{2}).(\d{3}.\d{2})</span>Net Worth</li>", match)
   netWorth=-%match1%%match2%
}

GoToPageCOM("http://www.usaa.com")
COM_Invoke(pwb, "document.all.j_username.value", "macnmel17")
COM_Invoke(pwb, "document.all.j_password.value", SexPanther())
COM_Invoke(pwb, "document.all.login.click")
WaitIEReady()

;sleepseconds(3)
;COM_Invoke(item723:=COM_Invoke(all2:=COM_Invoke(document:=COM_Invoke(pwb,"Document"),"All"),"Item",669),"value", sexpanther("pin"))
;COM_Invoke(item308:=COM_Invoke(all2:=COM_Invoke(document:=COM_Invoke(pwb,"Document"),"All"),"Item",667),"click")
sleepseconds(15)
sse(sexpanther("pin"))
COM_Invoke(pwb, "document.all.pin.value", SexPanther("pin"))

WaitIEReady()

SavingsBalance  := GetAccountInfoCOM("encrypted10bb142d9db5d1209462ee637b61c599")
CheckingBalance := GetAccountInfoCOM("encrypted10bb142d9db5d12081af1bd8872ba833")
CameronBalance  := GetAccountInfoCOM("encryptedb15eff1c50e20965749b3338ceff1d4379e5098d18308caa")
MelindaBalance  := GetAccountInfoCOM("encryptedb15eff1c50e209657b4e04143ceb8bdd5e1587891b30192c")

COM_Invoke(pwb, "Quit")
COM_Term()

overallBalance := SavingsBalance + CheckingBalance - CameronBalance - MelindaBalance
overallBalance := StringTrimRight(overallBalance, 4)

CameronProjection:=GetCreditCardProjection(CameronBalance, 22)
MelindaProjection:=GetCreditCardProjection(MelindaBalance, 12)

;output this stuff to a file
csvline:=ConcatWithSep(",", time, SavingsBalance, CheckingBalance, "", overallBalance, "", CameronBalance, CameronProjection, MelindaBalance, MelindaProjection, NetWorth)
FileAppendLine(csvline, csvfile)

;prep morning status file
FileDelete("gitExempt\morning_status\finance.txt")

ReportNightlyStats("financial", "FinancesDateUpdated", time)
ReportNightlyStats("financial", "NetWorth",            NetWorth)
ReportNightlyStats("financial", "SavingsBalance",      SavingsBalance)
ReportNightlyStats("financial", "CheckingBalance",     CheckingBalance)
ReportNightlyStats("financial", "CameronBalance",      CameronBalance)
ReportNightlyStats("financial", "MelindaBalance",      MelindaBalance)
ReportNightlyStats("financial", "OverallBalance",      OverallBalance)
ReportNightlyStats("financial", "CameronProjection",   CameronProjection)
ReportNightlyStats("financial", "MelindaProjection",   MelindaProjection)

ExitApp
;the end of the script

WaitIEReady()
{
   global pwb
   SleepSeconds(1)
   While, COM_Invoke( pwb, "ReadyState" ) <> 4
      Sleep, 10
   SleepSeconds(1)
   ;OptionalDebug("page is loaded")
}

;send, sleep, enter
sse(text="")
{
Sleep, 200
Send, %text%
Sleep, 200
Send, {ENTER}
}

GetAccountInfoCOM(key)
{
   global pwb
   url=https://www.usaa.com/inet/gas_bank/BkAccounts?target=AccountSummary&currentaccountkey=%key%&CombinedView=TRUE

   ;ensure returned value is not blank
   ;validating with regex to ensure we have a value
   while NOT RegExMatch(returned, "\d+\.\d\d")
   {
      returned := GetPageSource(url)

      ;find the account balance that we are looking for
      returned:=RegExReplace(returned, "(`r|`n)", " ")
      RegExMatch(returned, "<TH>(Current Balance).*?(</TR>)", returned)
      returned:=FormatDollar(returned)
   }
   return returned
}

GetCreditCardProjection(currentCreditBalance, endOfBillingCycle)
{
   ;do some math and get the projected CC bill
   FormatTime, currentDay, , dd
   daysThruBillingPeriod := mod( currentDay - endOfBillingCycle + 31, 31 )
   percentThru := daysThruBillingPeriod / 31 * 100
   percentLeft := 100 - percentThru
   spentPerPercent := currentCreditBalance / percentThru
   projectedCreditCardBill := currentCreditBalance + percentLeft * spentPerPercent
   projectedCreditCardBill := StringTrimRight(projectedCreditCardBill, 4)

   ;fix the projection if something odd is going on (like if the bill hasn't been paid yet)
   if (currentDay == endOfBillingCycle)
      projectedCreditCardBill := currentCreditBalance
   if (projectedCreditCardBill > 5000)
      projectedCreditCardBill := currentCreditBalance

   return projectedCreditCardBill
}

FormatDollar(amount)
{
   RegExMatch(amount, "(\d|,)*\.\d\d", returned)
   returned:=RegExReplace(returned, ",", "")
   return returned
}

;TODO we could come up with the var name by getting rid of spaces
;TODO this should do INI, CSV, and MorningStatus all at once
;thinking that CSV would be stupid to do at the same time
ReportNightlyStats(iniFile, varNameForIni, number)
{
   ini=C:\My Dropbox\AHKs\gitExempt\%iniFile%.ini
   IniWrite(ini, "", varNameForIni, number)
   MorningStatusAppend(varNameForIni, number)
}

GoToPageCOM(url)
{
   global pwb
   COM_Invoke(pwb, "Navigate", url)
   WaitIEReady()
}

GetPageSource(url)
{
   global pwb
   GoToPageCOM(url)
   returned := COM_Invoke(pwb, "document.documentElement.innerHTML")
   return returned
}

RunIECOM()
{
   global pwb
   COM_Init()
   pwb := COM_CreateObject("InternetExplorer.Application")
   COM_Invoke(pwb , "Visible=", "True")
   ;COM_Invoke(pwb, "Navigate", "javascript: alert('Hello World!')")
   ;WaitIEReady()
}
