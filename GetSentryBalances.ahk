#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include gitExempt/SentryLogin.ahk

time:=CurrentTime("hyphenated")
pricesFile=gitExempt/401k-prices.csv
totalsFile=gitExempt/401k-total.csv

SentryLogin()

if NOT ForceWinFocusIfExist("[Participant Summary] - Opera", "Exact")
   ExitApp

summary:=GhettoUrlDownloadToVar("https://sentryins.com/acctbal.aspx?VIEWMODE=I&LINK=50")
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
text=Sentry 401k Balance: %total%
FileAppendLine(text, "gitExempt\morning_status\finance-401k.txt")

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
