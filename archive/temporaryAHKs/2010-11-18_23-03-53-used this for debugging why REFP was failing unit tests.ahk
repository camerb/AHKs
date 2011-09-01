#include FcnLib.ahk
   RunWait, RegExFileProcessor.ahk

path=C:\Dropbox\AHKs\REFP\
outfile=%path%out1.txt
assertoutfile=%path%out2.txt

result:=IsFileEqual2(assertoutfile, outfile)
debugbool(result)

IsFileEqual2(filename1, filename2)
{
   FileRead, file1, %filename1%
   FileRead, file2, %filename2%

   debug(file1, file2)
   debug(strlen(file1), strlen(file2))
   ;Loop 6 {
      ;debug(substr(file2, A_Index))
   ;}
   return file1==file2
}
