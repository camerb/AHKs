#include FcnLib.ahk

joe:=urlDownloadToVar("http://www.autohotkey.net/~cameronbaustian/text.txt")
last:=urlDownloadToVar("http://dl.dropbox.com/u/789954/text.txt")
;debug("",joe)

if (joe != last)
{
   ;debug("silent log", "new version detected... going to run it")
   FileDelete, C:\Dropbox\Public\text.txt
   FileAppend, %joe%, C:\Dropbox\Public\text.txt
   timestamp := CurrentTime()
   FileAppend, %joe%, C:\Dropbox\AHKs\scheduled\phosphorus\%timestamp%.ahk
}


;also, i should consider the option of making the logs files stored in the public dropbox folder so i can get to it from the cloud pc
; there shouldn't be any personal info in there, should there?


;need a fcn that gives local dropbox folder location and remote dropbox folder location


