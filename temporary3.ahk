#include FcnLib.ahk

ss()
ForceWinFocus("Status Pro Initial Catalog=StatusPro; - Portal - Mozilla Firefox")

;Loop 3
   ;ClickIfImageSearch("images/firefly/feesButton.bmp")
;ss()
;WaitForImageSearch("images/firefly/feesWizardWindow.bmp")
ClickIfImageSearch("images/firefly/feesButton.bmp")
ss()
ClickIfImageSearch("images/firefly/feesButton.bmp")
ss()
ClickIfImageSearch("images/firefly/feesButton.bmp")
ss()
WaitForImageSearch("images/firefly/feesWizardWindow.bmp")

Loop 10
{
ss()
ForceWinFocus("Status Pro Initial Catalog=StatusPro; - Portal - Mozilla Firefox")
Click(539, 516, "left")
ss()
Click(549, 479, "left")
ss()
;Send, {ENTER}
ForceWinFocus("The page at https://www.status-pro.biz says:")
Click(120, 97, "left")
}
ss()
ForceWinFocus("Status Pro Initial Catalog=StatusPro; - Portal - Mozilla Firefox")
ss()
Click(1243, 425, "left")
ss()
Click(1243, 425, "left")
ExitApp

ESC::ExitApp
`::ExitApp

ss()
{
Sleep, 200
}
