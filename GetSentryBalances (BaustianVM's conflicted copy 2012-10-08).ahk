#include FcnLib.ahk
#include FcnLib-Nightly.ahk
;#include gitExempt/SentryLogin.ahk

time:=CurrentTime("hyphenated")
pricesFile=gitExempt/401k-prices.csv
totalsFile=gitExempt/401k-total.csv

SentryLogin()

summary:=iMacroUrlDownloadToVar("https://sentryins.com/acctbal.aspx?VIEWMODE=I&LINK=50")
summary:=RegExReplace(summary, "(`r|`n)", " ")

v1:=GetAccountUnitPrice(summary, "Diversified Income Account D -T.Rowe Price Spectrum Income Fund")
v2:=GetAccountUnitPrice(summary, "2045 Target Retirement LE - Sentry 2045 Target Retirement Portfolio")
v3:=GetAccountUnitPrice(summary, "Mid-Cap Growth Account I N - T Rowe Price Mid-Cap Growth Fund")
v4:=GetAccountUnitPrice(summary, "Aggressive Growth Account H - Janus Research Fund T Shares")
v5:=GetAccountUnitPrice(summary, "Diversified Growth Account AD - T Rowe Price Spectrum Growth Fund")
v6:=GetAccountUnitPrice(summary, "Concentrated Growth Account L - Janus Aspen Forty Portfolio")
v7:=GetAccountUnitPrice(summary, "Foreign Growth Account J - Janus Aspen Overseas Portfolio-Institutional Shares")
total:=GetAccountUnitPrice(summary, "Total\:")

csvLine:=concatWithSep(",", time, v1,v2,v3,v4,v5,v6,v7)
FileAppendLine(csvLine, pricesFile)
csvLine:=concatWithSep(",", time, total)
FileAppendLine(csvLine, totalsFile)
;text=Sentry 401k Balance: %total%
;FileAppendLine(text, "gitExempt\morning_status\finance-401k.txt")

NightlyStats("Sentry401k", total)

WinClose, Opera
SleepSeconds(5)
Process, Close, opera.exe

GetAccountUnitPrice(pageText, accountName)
{
   reNeedle=%accountName%(.*?)tr
   RegExMatch(pageText, reNeedle, block)
   RegExMatch(block1, "<td.*>\$([0-9,.]*?)</td", block)
   returned := RegExReplace(block1, ",")
   return returned
}

SentryLogin()
{
   ini := GetPath("questions.ini")

   panther:=sexpanther()
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
   TAB T=1
   URL GOTO=https://sentryins.com/default.aspx
   TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:loginform ATTR=ID:USERID CONTENT=camerb
   SET !ENCRYPTION NO
   TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:loginform ATTR=ID:PASSWDTXT CONTENT=%panther%
   TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:loginform ATTR=SRC:https://sentryins.com/graphics/buttons/login.gif
   )
   ;TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:layeredsecprompt ATTR=NAME:ANSWER CONTENT=purple
   ;TAG POS=1 TYPE=IMG ATTR=SRC:https://sentryins.com/graphics/buttons/submit.gif
   ;URL GOTO=https://sentryins.com/acctbal.aspx?VIEWMODE=I&LINK=50
   runimacro(imacro)
   securityQuestionPage:=iMacroUrlDownloadToVar()

   iniSection=sentry
   q1 := IniRead(ini, iniSection, "question1")
   q2 := IniRead(ini, iniSection, "question2")
   q3 := IniRead(ini, iniSection, "question3")
   a1 := IniRead(ini, iniSection, "answer1")
   a2 := IniRead(ini, iniSection, "answer2")
   a3 := IniRead(ini, iniSection, "answer3")

   debug()

   if InStr(securityQuestionPage, "Security Prompt")
   {
      if InStr(securityQuestionPage, q1)
         answer:=a1
      else if InStr(securityQuestionPage, q2)
         answer:=a2
      else if InStr(securityQuestionPage, q3)
         answer:=a3
      else
         fatalErrord("failed to recognize question", A_ScriptName, A_LineNumber, A_ThisFunc)

      ;debug(answer)
      ;VERSION BUILD=7400919 RECORDER=FX
      ;TAB T=1
      ;URL GOTO=https://sentryins.com/partlayeredsecprompt.aspx
      imacro=
      (
      TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:layeredsecprompt ATTR=NAME:ANSWER CONTENT=%answer%
      TAG POS=1 TYPE=IMG ATTR=SRC:https://sentryins.com/graphics/buttons/submit.gif
      )
      runimacro(imacro)
   }
}
