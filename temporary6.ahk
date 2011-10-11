#include FcnLib.ahk
#include FcnLib-Nightly.ahk

ini := GetPath("questions.ini")

panther:=sexpanther()
imacro=
(
VERSION BUILD=7300701 RECORDER=FX
TAB T=1
URL GOTO=https://sentryins.com/default.aspx
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:loginform ATTR=ID:USERID CONTENT=camerb
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:loginform ATTR=ID:PASSWDTXT CONTENT=%panther%
TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:loginform ATTR=SRC:https://sentryins.com/graphics/buttons/login.gif
)
;TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:layeredsecprompt ATTR=NAME:ANSWER CONTENT=purple
;TAG POS=1 TYPE=IMG ATTR=SRC:https://sentryins.com/graphics/buttons/submit.gif
;URL GOTO=https://sentryins.com/acctbal.aspx?VIEWMODE=I&LINK=50
runimacro(imacro)
securityQuestionPage:=iMacroUrlDownloadToVar()

iniSection=sentry
q1 := IniRead(ini, iniSection, "question1")
q2 := IniRead(ini, iniSection, "question2")
q3 := IniRead(ini, iniSection, "question3")
a1 := IniRead(ini, iniSection, "answer1")
a2 := IniRead(ini, iniSection, "answer2")
a3 := IniRead(ini, iniSection, "answer3")

addtotrace(WinGetActiveTitle())

if NOT InStr(securityQuestionPage, "Security Prompt")
{
   if InStr(securityQuestionPage, q1)
      SendInput, %a1%
   else if InStr(securityQuestionPage, q2)
      SendInput, %a2%
   else if InStr(securityQuestionPage, q3)
      SendInput, %a3%
   else
      fatalErrord("failed to recognize question", A_ScriptName, A_LineNumber, A_ThisFunc)

   Send, {ENTER}
}


;VERSION BUILD=7400919 RECORDER=FX
;TAB T=1
;URL GOTO=https://sentryins.com/partlayeredsecprompt.aspx
;TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:layeredsecprompt ATTR=NAME:ANSWER CONTENT=asdf
;TAG POS=1 TYPE=IMG ATTR=SRC:https://sentryins.com/graphics/buttons/submit.gif

addtotrace(WinGetActiveTitle())
