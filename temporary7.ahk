#include FcnLib.ahk
#include FcnLib-Nightly.ahk

joe:=SexPanther("pin")
joseph:=SexPanther()
macro=
(
VERSION BUILD=7300701 RECORDER=FX
TAB T=1
URL GOTO=https://www.usaa.com/inet/ent_logon/Logon
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:Logon ATTR=ID:usaaNum CONTENT=macnmel17
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:Logon ATTR=ID:usaaPass CONTENT=%joseph%
TAG POS=1 TYPE=BUTTON ATTR=ID:login
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:CpEnterPinPage ATTR=ID:cppindatacontainer.verifypin CONTENT=%joe%
TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:CpEnterPinPage ATTR=NAME:PsButton_[action]Update[/action]&&SRC:https://content.usaa.com/mcontent/static_assets/Media/g_transparent.gif?cacheid=3007383100
)
runimacro(macro)
