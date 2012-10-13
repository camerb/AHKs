#include FcnLib.ahk
#include FcnLib-Nightly.ahk
#include Lynx-FcnLib.ahk
#include Lynx-ProcedureParts.ahk
#include Lynx-UpdateParts.ahk

;Download current Lynx Version, ensure FTP site reads correct version

DownloadLynxFile("7.12.zip")
CopyFile("C:\temp\lynx_update_files\7.12\version.txt", "T:\TechSupport\upgrade_files\version.txt", "overwrite")
