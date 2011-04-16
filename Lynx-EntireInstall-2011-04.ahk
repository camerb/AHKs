#include FcnLib.ahk

if (A_ScreenWidth > 1280)
   errord("nolog", "WARNING: The Lynx Server Install is designed to run on the physical machine, is appears as if you are running the script while logged in through Remote Desktop. The installation will continue, but proceed carefully.`n`nPress ESC at any time to cancel.")
else
   debug("Starting Lynx Server Installation`n`nPress ESC at any time to cancel.")

#Include Lynx-0-ConfigureComputer.ahk
#Include Lynx-1-PrepForInstall.ahk
#Include Lynx-2-ActivePerl.ahk
#Include Lynx-3-InstallSQL.ahk
#Include Lynx-4-ConfigureSQL.ahk
#Include Lynx-5-Apache.ahk
#Include Lynx-6-TTS.ahk
MsgBox, Finished with Lynx Server Install

#include Lynx-FcnLib.ahk
