;#include FcnLib.ahk

;FcnLib-Rewrites.ahk by camerb

;This library contains those functions that reproduce functionality in AHK_basic, but which have significant differences in usage and/or side effects. The differences in functionality in these functions were found to be preferable over the functionality of the commands as they are in plain AHK

;{{{ File Manipulation Functions
FileAppend(text, file)
{
   EnsureDirExists(file)
   FileAppend, %text%, %file%
   ;TODO should we ensure that the file exists?
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
      fatalErrord("file doesn't exist", source, A_ThisFunc, A_LineNumber)
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
      fatalErrord("file doesn't exist", source, A_ThisFunc, A_LineNumber)
   EnsureDirExists(dest)

   FileMove, %source%, %dest%, %overwrite%
}

FileCreate(text, file)
{
   FileDelete(file)
   FileAppend(text, file)
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
   if (key == "")
      fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no key was provided for writing the ini value to")
   if (section == "")
      section:="default"

   IniWrite, %value%, %file%, %section%, %key%
   ;TODO test if the file is there
   if NOT FileExist(file)
   {
      errord("wrote to ini file, but it doesn't exist", file)
      return "error"
   }
}

IniDelete(file, section, key="")
{
   global A_IniFile
   if (file == "")
      file:=A_IniFile
   if (file == "")
      fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no filename was provided for deleting the ini value from")
   ;if (key == "")
      ;fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no key was provided for deleting the ini value from")
   if (section == "")
      section:="default"

   if (key == "")
      IniDelete, %file%, %section%
   else
      IniDelete, %file%, %section%, %key%
}

IniRead(file, section, key, Default = "ERROR")
{
   global A_IniFile
   if (file == "")
      file:=A_IniFile
   if (file == "")
      fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no filename was provided for reading the ini value from")
   if (key == "")
      fatalErrord(A_ThisFunc, A_ThisLine, A_ScriptName, "no key was provided for reading the ini value from")
   if (section == "")
      section:="default"
   IniRead, value, %file%, %section%, %key%, %Default%
   Return, value
}

;ok, these two aren't actually rewrites of things that are core
; but these functions probably should have been core
#include thirdParty/ini.ahk
IniListAllSections(file)
{
   content := FileRead(file)
   return ini_getAllSectionNames(content)
}

IniListAllKeys(file, section="") ;defaults to all sections
{
   content := FileRead(file)
   return ini_getAllKeyNames(content, section)
}

;}}}

;{{{ Process Manipulation

GetPID(exeName)
{
   Process, Exist, %exeName%
   return ERRORLEVEL
}

ProcessExist(exeName)
{
   Process, Exist, %exeName%
   return !!ERRORLEVEL
}

ProcessClose(exeName)
{
   Process, Close, %exeName%
}

ProcessCloseAll(exeName)
{
   while ProcessExist(exeName)
   {
      ProcessClose(exeName)
      Sleep, 100
   }
}

;}}}

;{{{ String Manipulation
StringReplace(ByRef InputVar, SearchText, ReplaceText = "", All = "A") {
	StringReplace, v, InputVar, %SearchText%, %ReplaceText%, %All%
	Return, v
}
;}}}
