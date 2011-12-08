#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;Touch Mint.com so that they will pull our account info (takes a while)
MintLogIn()
MintTouch()

if (A_ComputerName="PHOSPHORUSVM")
{
   Sleep, 500
   ProcessCloseAll("firefox.exe")
   ProcessCloseAll("firefoxPortable.exe")
}
ExitApp
