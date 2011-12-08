#include FcnLib.ahk

WinGetActiveTitle, titleofwin

if RegExMatch(titleofwin, "GVIM")
{
   postit.="dip  delete paragraph`ndi{  delete braced section`n=G   format selection (more than =)`nset go += T`nso! tabshow.vim`n,c{space} comment selection`nggVG select all`nA  insert at end`nI   insert at beginning`n! perl % run current perl file`nCtrl+W, S split (same file)`nCtrl+W, V vert split (same file)`nzM close all folds`nzR open all folds`n"
}
if RegExMatch(titleofwin, "AHKs.*GVIM")
{
   postit.="^  Control`n+  Shift`n!  Alt`n#  Win`ncmdLineArg1=%1%`n"
}
if RegExMatch(titleofwin, "Irssi")
{
   postit.="skylordikins: stfu skylordikins <reply>$who: shut up`n/names (shows those connected)`n/netsplit (shows those split off from you)`n!com std lib`n!ahk lib collection`n"
}
if RegExMatch(titleofwin, "Microsoft SQL Server Management Studio")
{
   postit.="UPDATE tablename`n   SET columnname = expr`n   WHERE predicates;`n`nWHERE id IN (1,2,3);`n`nALTER TABLE tablename`n   ALTER COLUMN column datatype NOT NULL;`n`nselect * from message_queue where data like '%mkits/simple%';`n"
}

if postit
   Msgbox % postit
