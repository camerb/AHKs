#include FcnLib.ahk

path="C:\Dropbox\AHKs\REFP\
infile=%path%in1.txt"
refile2=%path%regex-rawmacro.txt"
outfile=%path%out1.txt"

params := concatWithSep(" ", infile, refile2, outfile)
RunAhk("RegExFileProcessor.ahk", params)

;Run, "RegExFileProcessor.ahk hi"
   ;FileRead, out, %outfile%
   ;debug("launcher", result)

;PrependPath(filename)
pp(filename)
{
   path=C:\Dropbox\AHKs\REFP\
   returned=%path%%filename%
   return returned
}
