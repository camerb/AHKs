#include FcnLib.ahk

param=%1%

;completed features
assert("asdf", "jkl`nuiop", "asdf", "no matches")
assert("asdf", "asdf`nuiop", "uiop", "simple match")
assert("turkey, duck, chicken", "^(.{3}).* (.*),.*(.{2})$`n$1$2$3", "turducken", "replace with subselect")
assert("asdf`nqsdf`nzsdf", "sdf`nuiop", "auiop`nquiop`nzuiop", "multiline")
assert("auiop`nquiop`nzuiop", "(quiop)`n$1#suppresscrlf", "auiop`nquiopzuiop", "multiline, suppressCRLF")
assert("hi`njoe`nalfred", "joe`n#delline", "hi`nalfred", "using #delline command")
assert("1`t2`t3", "#tab`n,", "1,2,3", "convert tsv to csv using #tab")
assert("hi`njoe`nalfred", "joe`n#elimRowsThatDontMatch", "joe", "using #elimRowsThatDontMatch command")

if (param == "completedFeaturesOnly")
   ExitApp

;unit tests for features that aren't finished yet

assert(inContents, reContents, outContents, description)
{
   path=C:\Dropbox\AHKs\REFP\
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
