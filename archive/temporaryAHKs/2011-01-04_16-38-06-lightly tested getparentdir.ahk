#include FcnLib.ahk

debug(parentdir(A_ScriptFullPath))
debug(parentdir("C:\My Dropbox\"))

ParentDir(fileOrFolder)
{
   if (StringRight(fileOrFolder, 1) == "\")
      fileOrFolder:= StringTrimRight(fileOrFolder, 1)
   RegexMatch(fileOrFolder, "^.*\\", returned)
   return returned
}
