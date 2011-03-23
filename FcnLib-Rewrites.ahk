#include FcnLib.ahk

;FcnLib-Rewrites.ahk by camerb

;This library contains those functions that reproduce functionality in AHK_basic, but which have significant differences in usage and/or side effects. The differences in functionality in these functions were found to be preferable over the functionality of the commands as they are in plain AHK

;{{{ File Manipulation Functions
FileAppend(text, file)
{
   EnsureDirExists(file)
   FileAppend, %text%, %file%
}

FileAppendLine(text, file)
{
   text.="`r`n"
   return FileAppend(text, file)
}

FileCopy(source, dest, options="")
{
   if InStr(options, "overwrite")
      overwrite=1
   if NOT FileExist(source)
      fatalErrord("file doesn't exist")
   EnsureDirExists(dest)

   FileCopy, %source%, %dest%, %overwrite%
}

FileDelete(file)
{
   ;nothing is wrong if the file is already gone
   if NOT FileExist(file)
      return

   FileDelete, %file%
}

FileMove(source, dest, options="")
{
   if InStr(options, "overwrite")
      overwrite=1
   if NOT FileExist(source)
      fatalErrord("file doesn't exist")
   EnsureDirExists(dest)

   FileCopy, %source%, %dest%, %overwrite%
}

;}}}

;{{{ INI Functions

;TESTME
IniWrite(file, section, key, value)
{
   ;TODO put this in the read write and delete fcns
   global A_IniFile
   if (file == "")
      file:=A_IniFile
   if (file == "")
      fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no filename was provided for writing the ini to")
   if (section == "")
      section:="default"

   IniWrite, %value%, %file%, %section%, %key%
   ;TODO test if the file is there
   ;if NOT FileExist(file)
   ;   return "error"
}

IniDelete(file, section, key="")
{
   ;if NOT FileExist(file)
   ;   return "error"

   if (key == "")
      IniDelete, %file%, %section%
   else
      IniDelete, %file%, %section%, %key%
}

IniRead(Filename, Section, Key, Default = "ERROR") {
	IniRead, v, %Filename%, %Section%, %Key%, %Default%
	Return, v
}

;}}}
