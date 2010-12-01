;used this to generate the batch file that parsed data into the FL DB (from each state-in separate files)

#include FcnLib.ahk

Loop, C:\code\Bench(with parser)\data\*.txt, 0, 1
{
   FileAppend, `nperl reparser.pl `"%A_LoopFileFullPath%`", C:\code\Bench(with parser)\run.bat
}
