;#include FcnLib.ahk

;FcnLib-Rewrites.ahk by camerb

;This library contains those functions that reproduce functionality in AHK_basic, but which have significant differences in usage and/or side effects. The differences in functionality in these functions were found to be preferable over the functionality of the commands as they are in plain AHK (that's just my opinion, though)

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

;A simple little function, probably isn't performed as quickly as it could be, but what's the harm?
FileLineCount(file)
{
   Loop, read, %file%
      returned:=A_Index
   return returned
}
;}}}

;{{{Folder Manipulation Functions

;TESTME
FileCopyDir(source, dest, options="")
{
   if InStr(options, "overwrite")
      overwrite=1

   if NOT DirExist(source)
      return false
   EnsureDirExists(dest)

   FileCopyDir, %source%, %dest%, %overwrite%
}

;TODO consider a rename to FileDeleteDirForceful (or forceful option)
;Delete folder very forcefully
FileDeleteDirForceful(dir)
{
   ;this will delete as much as possible from the target folder
   ;depending upon file locks, some items may not get deleted

   if NOT DirExist(dir)
      return

   dir:=EnsureEndsWith(dir, "\")
   dir:=EnsureEndsWith(dir, "*")

   ;delete as many files as we possibly can (typically difficult in windows)
   Loop, %dir%, , 1
   {
      FileDelete, %A_LoopFileFullPath%
   }

   ;delete all the folders that we can
   Loop, %dir%, 2, 1
   {
      FileRemoveDir, %A_LoopFileFullPath%, 1
   }
}

;Returns if the directory exists
;FIXME hmm, perhaps I should have named this starting with the word "file"
;TODO rename all instances of DirExist to FileDirExist
FileDirExist(dirPath)
{
   return InStr(FileExist(dirPath), "D") ? 1 : 0
}
DirExist(dirPath)
{
   return FileDirExist(dirPath)
}

;Creates the parent dir if necessary
;TODO if path is a directory, this ensures that that dir exists
;simply: this ensures that the entire specified dir structure exists
EnsureDirExists(path)
{
   ;if path is a file, this ensures that the parent dir exists
   dir:=ParentDir(path)

   ;figure out if it is a file or dir
   ;split off filename if applicable
   FileCreateDir, %dir%
}

;TESTME
;Gets the parent directory of the specified directory
ParentDir(fileOrFolder)
{
   fileOrFolder := RegExReplace(fileOrFolder, "(\\|/)", "\")
   if (StringRight(fileOrFolder, 1) == "\")
      fileOrFolder:= StringTrimRight(fileOrFolder, 1)
   RegexMatch(fileOrFolder, "^.*\\", returned)
   return returned
}
;}}}

;{{{ INI Functions

;TESTME
IniWrite(file, section, key, value)
{
   ;sanitize key and value (replace with NAK to indicate an error)
   key := RegExReplace(key, "(\r|\n)", "?")
   value := RegExReplace(value, "(\r|\n)", "?")
   EnsureDirExists(file)

   ;TODO put this in the read write and delete fcns
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
   ;sanitize key and value (replace with NAK to indicate an error)
   key := RegExReplace(key, "(\r|\n)", "?")
   ;EnsureDirExists(file)

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

   ;TODO perhaps we should return what the old value was?
}

IniRead(file, section, key, Default = "ERROR")
{
   ;sanitize key and value (replace with NAK to indicate an error)
   ;TODO get a better value!!! NAK was bad, but ? would probably be used...
   key := RegExReplace(key, "(\r|\n)", "?")
   ;EnsureDirExists(file)

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
   ;FIXME
   ;this waits for all processes to get closed...
   ;something like "taskkill /f /im perl.exe" would be best, but that would require external libs
   ;another solution is to just get a list of all processes with that name and ProcessClose() each one
   ;   that would not wait for each one to close
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

;{{{ Misc
Reload()
{
   Reload
   Sleep, 60000 ;noticed that reload doesn't reload instantly
}
;}}}
