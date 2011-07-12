#include FcnLib.ahk
#include FcnLib-Rewrites.ahk

ini:=GetPath("NightlyStats.ini")
csv:=GetPath("FinancialPast.csv")
date:=CurrentTime("hyphendate")
CreateCSV(ini, csv, "SavingsBalance,CheckingBalance,CameronBalance,MelindaBalance,OverallBalance")

;make a csv from the data in the ini
;date is automatically prepended to the headings
CreateCSV(ini, csv, headings)
{
   sections:=IniListAllSections(ini)
   ;debug(sections, date)

   ;Print Headings in new CSV file
   FileDelete(csv)
   csvline:=ConcatWithSep(",", "Date", headings)
   FileAppendLine(csvline, csv)

   ;Loop per day
   Loop, parse, sections, CSV
   {
      section:=A_LoopField
      csvline:=section

      ;Get each value in the line
      Loop, parse, headings, CSV
      {
         heading:=A_LoopField
         value:=IniRead(ini, section, heading)
         if (value == "ERROR")
            value=
         csvline:=ConcatWithSep(",", csvline, value)
      }
      FileAppendLine(csvline, csv)
   }
}
