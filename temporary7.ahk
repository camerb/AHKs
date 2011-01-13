#include FcnLib.ahk

;this is how to tell what the name of the current branch is
varContainingCurrentGitBranch := FileRead("C:\code\epms\.git\HEAD")
debug(varContainingCurrentGitBranch)
