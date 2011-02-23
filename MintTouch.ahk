#include FcnLib.ahk
#include FcnLib-Opera.ahk
#include C:\My Dropbox\AHKs\gitExempt\usaalogin.ahk
#include MintLogin.ahk

;Touch Mint.com so that they will pull our account info (takes a while)

mintlogin()

WaitForImageSearch("images/mint/UpdateAccountsButton.bmp")
Sleep, 500
ClickIfImageSearch("images/mint/UpdateAccountsButton.bmp")
Click

ExitApp
`:: ExitApp
