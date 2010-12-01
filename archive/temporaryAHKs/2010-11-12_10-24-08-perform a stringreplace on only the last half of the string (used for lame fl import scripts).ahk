#include FcnLib.ahk

FileDelete, C:\fl-dup\out2.txt

search=)->update({$fieldname=>"
repl=,

;debug(search)
Loop, read, C:\fl-dup\out1.txt
{
   num=40
   StringLeft, linestart, A_LoopReadLine, num
   StringTrimLeft, lineend, A_LoopReadLine, num
   StringReplace, newlineend, lineend, %search%, %repl%, 1
   newfullline := linestart . newlineend . "`n"
   FileAppend, %newfullline%, C:\fl-dup\out2.txt
   ;if (InStr(linestart, 192))
   ;{
      ;;debug(linestart)
      ;debug(lineend)
      ;debug(newlineend)
      ;ExitApp
   ;}
}
