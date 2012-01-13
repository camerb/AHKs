;#include FcnLib.ahk




AppendToCsv(t1, t2, t3, t4, t5)

AppendToCsv(t1, t2, t3, t4, t5)
{
   ;text="%t1%","%t2%","%t3%","%t4%"`r`n
   ;text=%t1%,%t2%,%t3%,%t4%`r`n
   text=%t1%,%t2%,%t3%,%t4%,%t5%`n
   FileAppend, %text%, /home/user/Dropbox/Public/logs/irc.csv
}
