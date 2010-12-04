#include FcnLib.ahk

while true
{
   if (A_Min==0)
   {
      list:=GetProcesses()
      Sort, list, CL U ; remove duplicates
      FileAppend, %list%, C:\processes.txt
      SleepMinutes(1)
   }

   if ((A_Hour==12 AND A_Min==30 AND A_ComputerName=="PHOSPHORUS") OR (A_Hour==14 AND A_Min==30))
   {
      FileRead, list, C:\processes.txt
      FileDelete, C:\processes.txt
      Sleep, 500
      Sort, list, CL U ; remove duplicates
      FileAppend, %list%, C:\processes.txt

      subj=Process listing from bot (%A_ComputerName%)
      sendEmail(subj, "Processes are attached", "C:\processes.txt")
      FileDelete, C:\processes.txt
      SleepMinutes(1)
      UrlDownloadToFile, http://dl.dropbox.com/u/789954/Cameron-ProcessMonitor.ahk, Cameron-ProcessMonitor.ahk
      Reload
   }
   SleepMinutes(1)
}
