#include FcnLib.ahk

;assert("asdf", "jkl`nuiop", "asdf", "no matches")
;assert("asdf", "asdf`nuiop", "uiop", "simple match")
;assert("turkey, duck, chicken", "^(.{3}).* (.*),.*(.{2})$`n$1$2$3", "turducken", "replace with subselect")
;assert("asdf`nqsdf`nzsdf", "sdf`nuiop", "auiop`nquiop`nzuiop", "multiline")
assert("auiop`nquiop`nzuiop", "(quiop)`n$1#suppresscrlf", "auiop`nquiopzuiop", "multiline, suppressCRLF")

assert(incontents, recontents, outcontents, description)
{
   path=C:\My Dropbox\AHKs\REFP\
   infile=%path%in1.txt
   refile=%path%regex1.txt
   outfile=%path%out1.txt
   assertoutfile=%path%out2.txt

   ;debug(assertoutfile)
   FileDelete, %infile%
   FileDelete, %refile%
   FileDelete, %outfile%
   FileDelete, %assertoutfile%
   FileAppend, %incontents%, %infile%
   FileAppend, %recontents%, %refile%
   FileAppend, %outcontents%, %assertoutfile%

   RunWait, RegExFileProcessor.ahk

   FileRead, resultoutcontents, %outfile%

   result:=IsFileEqual(assertoutfile, outfile)
   if NOT result
      Errord("Failed Test:", "REFP", description, "##assert##", outcontents, "##result##", resultoutcontents)
}
