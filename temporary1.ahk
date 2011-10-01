#include FcnLib.ahk

cpath=C:\Home Backups\160GB\
e=E:\
f=F:\

compareSizesOfBackups(f, "Dev-cpp")
compareSizesOfBackups(f, "Documents and Settings")
compareSizesOfBackups(f, "Program Files")
compareSizesOfBackups(f, "WINDOWS")
;compareSizesOfBackups(f, "Downloads")
;compareSizesOfBackups(f, "Music")

;msg=esize: %esize%`nfsize: %fsize%`nbackup Size: %backupsize%`ntotal size:  %addsize%
errord("red line", msg)

compareSizesOfBackups(originalLocation, folder)
{
global
origdir=%originalLocation%%folder%
bkupdir=%cpath%%folder%
origsize := DirGetSize(origdir)
bkupsize := DirGetSize(bkupdir)
thisItem = `n`nfolder: %folder%`norig size: %origsize%`nbkup size: %bkupsize%
msg .= thisItem
}
