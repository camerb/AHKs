#include FcnLib.ahk
#include FcnLib-Nightly.ahk

imacro=
(
VERSION BUILD=7300701 RECORDER=FX
TAB T=1
URL GOTO=https://sentryins.com/default.aspx
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:loginform ATTR=ID:USERID CONTENT=camerb
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:loginform ATTR=ID:PASSWDTXT CONTENT=after96close
TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:loginform ATTR=SRC:https://sentryins.com/graphics/buttons/login.gif
)
;TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:layeredsecprompt ATTR=NAME:ANSWER CONTENT=purple
;TAG POS=1 TYPE=IMG ATTR=SRC:https://sentryins.com/graphics/buttons/submit.gif
;URL GOTO=https://sentryins.com/acctbal.aspx?VIEWMODE=I&LINK=50
runimacro(imacro)
