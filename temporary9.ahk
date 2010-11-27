#include FunctionLibrary.ahk

file=C:\My Dropbox\Public\remote.txt

Loop
{
var:=Random(100, 999)
FileDelete
FileAppend
SleepSeconds(10)
}
