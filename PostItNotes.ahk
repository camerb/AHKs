#include FcnLib.ahk

WinGetActiveTitle, titleofwin

if RegExMatch(titleofwin, "AHKs.*GVIM")
{
   postit:="^  Control`n+  Shift`n!  Alt`n#  Win"
}
if RegExMatch(titleofwin, "Irssi")
{
   postit:="skylordikins: stfu skylordikins <reply>$who: shut up`n/names (shows those connected)`n/netsplit (shows those split off from you)"
}
if RegExMatch(titleofwin, "Microsoft SQL Server Management Studio")
{
   postit:="UPDATE tablename`n   SET columnname = expr`n   WHERE predicates;`n`nWHERE id IN (1,2,3);`n`nALTER TABLE tablename`n   ALTER COLUMN column datatype NOT NULL;`n"
}

if postit
   Msgbox % postit
