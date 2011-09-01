#include FcnLib.ahk

file=C:\Dropbox\Public\remotewidget.txt

Loop
{
rand:=Random(100, 999)
FileDelete, %file%
FileAppend, %rand%`nhello, %file%
FileAppend, `nft, %file%

SleepSeconds(20)
}
