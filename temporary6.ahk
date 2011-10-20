#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;Test Lynx

iMacro=
(
VERSION BUILD=7401004 RECORDER=FX
TAB T=1
URL GOTO=http://t-800/cgi/checkhome.plx
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:Login_Form ATTR=NAME:UserID CONTENT=security
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:Login_Form ATTR=NAME:Password CONTENT=test
TAG POS=1 TYPE=INPUT:SUBMIT FORM=NAME:Login_Form ATTR=NAME:Enter&&VALUE:Enter<SP>Site
URL GOTO=t-800/cgi/sendmessage.plx
TAG POS=1 TYPE=TEXTAREA FORM=ACTION:/cgi/sendmessage.plx ATTR=NAME:Also CONTENT=CPU/%A_ComputerName%
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:/cgi/sendmessage.plx ATTR=NAME:Subject CONTENT=test<SP>message
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ACTION:/cgi/sendmessage.plx ATTR=NAME:SUBMIT&&VALUE:Send<SP>Message
)
RunIMacro(iMacro)

WinWaitActive, Lynx Alert
Send, ^w
debug("lynx tests passed")
