#include FunctionLibrary.ahk

file=C:\My Dropbox\Public\remotewidget.txt

Loop
{
var:=Random(100, 999)
FileDelete, %file%
FileAppend, %var%`r`nhello, %file%
FileAppend, `r`nft, %file%
SleepSeconds(20)
}
