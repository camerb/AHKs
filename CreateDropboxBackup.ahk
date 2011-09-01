;Creates a 7zip backup archive of the dropbox

#include FcnLib.ahk

archiveFilename := CurrentTime("hyphenated")
archivePath=C:\DataExchange\DropboxArchive
FileCreateDir, %archivePath%

command="C:\Program Files\7-Zip\7z.exe" a -t7z %archivePath%\%archiveFilename%.7z "C:\Dropbox"

Run, %command%

;TODO may need to make a "run at cmd prompt" function

;TODO also back up Google Chrome bookmarks
