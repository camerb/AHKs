#include FcnLib.ahk

;Function Library for items that seem like they need their own function lib file, but there aren't enough fcns yet
;for instance, I have a feeling that there will be a FcnLib-Git someday, but I just don't have enough git functions to justify it yet.

#include thirdParty/cmdret.ahk
GitGetCurrentBranchName()
{
   branchNameFromFile := FileRead("C:\code\epms\.git\HEAD")
   RegExMatch(branchNameFromFile, "heads\/(.*)\n", branchName)
   branchNameFromFile:=branchName1
   return branchNameFromFile
}

GitGetIssueNumber(currentBranchName)
{
   RegExMatch(currentBranchName, "(\w+-\d+)", match)
   return match1
}

;WRITEME
GitGetIssueTitle(issueNumber)
{
   command=perl C:\code\mtsi-scripts\jira-issue-title.pl %issueNumber%
   issueTitle := CmdRet_RunReturn( command )
   ;TODO validation to ensure there are no exceptions from Jira
   if InStr(message, "exception")
      fatalErrord("", "an exception occurred when getting the title of the issue from jira")
   return issueTitle
}

;write all this info out to the ini, csv and morning status email
NightlyReportStats(title, data)
{
   if NOT title
      return
   if NOT data
      return

   ini=C:\My Dropbox\AHKs\gitExempt\financial.ini
   time:=CurrentTime("hyphenated")
   ;csvfile=C:\My Dropbox\AHKs\gitExempt\DailyFinancial.csv

   IniWrite(ini, title, "time", time)
   IniWrite(ini, title, "data", data)

   MorningStatusAppend("NetWorth", NetWorth)
}
