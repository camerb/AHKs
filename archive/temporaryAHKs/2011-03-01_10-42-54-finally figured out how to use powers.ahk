#include FcnLib.ahk


   size:=dirgetsize("C:\Dropbox\")
   d := 1024 * 3
   dropboxSize := size / (1024 ** 3)
   ;dropboxSize := size / d
   dropboxSize2 := size/1000000000
   message=Dropbox: %dropboxSize% %dropboxSize2% of 3 GB used
   debug(message, filename)
