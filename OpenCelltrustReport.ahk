#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;TAG POS=1 TYPE=A ATTR=TXT:LOGOUT

lalala:=SexPanther("celltrust")
imacro=
(
URL GOTO=https://gateway.celltrust.net/PMWeb/jsp/pages/report/reportSentCampaign2.jsf
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:/PMWeb/jsp/pages/login/login.jsf ATTR=NAME:thirdColumn:login:_id9:_id11 CONTENT=mitsi
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=ACTION:/PMWeb/jsp/pages/login/login.jsf ATTR=NAME:thirdColumn:login:_id9:_id13 CONTENT=%lalala%
TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:thirdColumn:login:_id9 ATTR=NAME:thirdColumn:login:_id9:_id14&&SRC:https://gateway.celltrust.net/PMWeb/jsp/images/login-button.png
URL GOTO=https://gateway.celltrust.net/PMWeb/jsp/pages/common/welcome.jsf
TAG POS=1 TYPE=A ATTR=TXT:Total<SP>Messages<SP>Sent
TAG POS=1 TYPE=A ATTR=ID:body:viewReportSentCampaign:viewReportData:_id78:SendDateLink
TAG POS=1 TYPE=A ATTR=ID:body:viewReportSentCampaign:viewReportData:_id78:SendDateLink
)

RunIMacro(imacro)
