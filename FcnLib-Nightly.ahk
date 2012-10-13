#include FcnLib.ahk
#include FcnLib-iMacros.ahk

;Function lib for things that are too ghetto to happen during the day
;iMacros are also generally too ghetto for the daytime

;{{{ Mint Functions
MintLogIn()
{
   panther:=SexPanther()
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
   URL GOTO=https://wwws.mint.com/login.event?task=L
   TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:loginUserSubmit.xevent ATTR=ID:form-login-username CONTENT=cameronbaustian@gmail.com
   SET !ENCRYPTION NO
   TAG POS=1 TYPE=INPUT:PASSWORD FORM=ACTION:loginUserSubmit.xevent ATTR=ID:form-login-password CONTENT=%panther%
   TAG POS=1 TYPE=LI ATTR=ID:log_in
   TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:form-login ATTR=VALUE:Log<SP>In
   TAG POS=1 TYPE=A ATTR=TXT:Transactions
   URL GOTO=https://wwws.mint.com/transaction.event
   )

   RuniMacro(imacro)
}

MintGetTransactionCsvs()
{
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
   URL GOTO=https://wwws.mint.com/transaction.event
   TAG POS=1 TYPE=A ATTR=TXT:Transactions
   ONDOWNLOAD FOLDER=C:\Dropbox\AHKs\GitExempt\mint_export\ FILE={{!NOW:yyyy-mm-dd}}.csv WAIT=YES
   TAG POS=1 TYPE=A ATTR=ID:transactionExport
   )

   RuniMacro(imacro)
}

MintTouch()
{
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
   URL GOTO=https://wwws.mint.com/overview.event
   TAG POS=1 TYPE=A ATTR=ID:module-accounts-update
   )

   RuniMacro(imacro)
}
;}}}
