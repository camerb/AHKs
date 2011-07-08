#include FcnLib.ahk
#include FcnLib-Rewrites.ahk

ini:=GetPath("NightlyStats.ini")
date:=CurrentTime("hyphendate")

sections:=IniListAllSections(ini)
debug(sections, date)

keys:=IniListAllKeys(ini, date)
debug(keys)
