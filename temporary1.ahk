#include FcnLib.ahk

cpath=C:\Home Backups\40GB\
e=E:\
f=F:\

compareSizesOfBackups(e, "DataExchange")
compareSizesOfBackups(e, "dell")
compareSizesOfBackups(e, "Documents and Settings")
compareSizesOfBackups(e, "My Downloads")
compareSizesOfBackups(e, "Papyrus")
compareSizesOfBackups(e, "Program Files")
compareSizesOfBackups(e, "WINDOWS")
;compareSizesOfBackups(f, "Downloads")
;compareSizesOfBackups(f, "Music")

;msg=esize: %esize%`nfsize: %fsize%`nbackup Size: %backupsize%`ntotal size:  %addsize%
errord("red line", msg)

compareSizesOfBackups(originalLocation, folder)
{
global
origdir=%cpath%%folder%
bkupdir=%originalLocation%%folder%
origsize := DirGetSize(origdir)
bkupsize := DirGetSize(bkupdir)
thisItem = `n`nfolder: %folder%`norig size: %origsize%`nbkup size: %bkupsize%
msg .= thisItem
}
