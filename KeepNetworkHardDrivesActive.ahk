#include FcnLib.ahk

computerList=test,release,t-2008,t-2003,t-1,t-800
Loop, parse, computerList, CSV
{
   thisComputer := A_LoopField
   thisPath=\\%thisComputer%\c$\test.txt
   InitializeConnection(thisPath)
}

computerList=L,T
Loop, parse, computerList, CSV
{
   thisDriveLetter := A_LoopField
   thisPath=%thisDriveLetter%:\test.txt
   InitializeConnection(thisPath)
}

InitializeConnection(path)
{
   FileDelete, %path%
   FileAppend, t, %path%
   FileDelete, %path%
}
