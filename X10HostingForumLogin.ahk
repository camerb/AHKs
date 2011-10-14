#include FcnLib.ahk
#include FcnLib-Nightly.ahk

panther := SexPanther()
imacro=
(
VERSION BUILD=7400919 RECORDER=FX
TAB T=1
URL GOTO=http://x10hosting.com/forums/
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:http://x10hosting.com/forums/login.php?do=login ATTR=ID:navbar_username CONTENT=cameronbaustian29
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=ACTION:http://x10hosting.com/forums/login.php?do=login ATTR=ID:navbar_password CONTENT=%panther%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:navbar_loginform ATTR=VALUE:Log<SP>in
URL GOTO=http://x10hosting.com/forums/
ONDIALOG POS=1 BUTTON=OK CONTENT=
TAG POS=1 TYPE=A ATTR=TXT:Log<SP>Out
)
RuniMacro(imacro)
