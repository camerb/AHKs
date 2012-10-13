#include FcnLib.ahk


joe := SexPanther()

imacro=
(
VERSION BUILD=7500718 RECORDER=FX
TAB T=1
URL GOTO=http://sms1.mitsi.com/Auth/logout
URL GOTO=http://sms1.mitsi.com/
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:NoFormName ATTR=ID:ext-comp-1009 CONTENT=cameron
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:NoFormName ATTR=ID:ext-comp-1010 CONTENT=%joe%
TAG POS=1 TYPE=BUTTON ATTR=ID:ext-gen60

TAG POS=1 TYPE=SPAN ATTR=TXT:Account<SP>Management
TAG POS=1 TYPE=SPAN ATTR=TXT:Accounts
TAG POS=1 TYPE=BUTTON ATTR=ID:ext-gen110

)
RunIMacro(imacro)

Send, text text text





/*
`TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:NoFormName ATTR=ID:ext-comp-1039 CONTENT=VA<SP>Dorn
`TAG POS=1 TYPE=IMG ATTR=ID:ext-gen159
`TAG POS=1 TYPE=DIV ATTR=TXT:200<SP>/<SP>Month<SP>with<SP>support
`TAG POS=1 TYPE=BUTTON ATTR=ID:ext-gen151
*/

 ~esc::ExitApp