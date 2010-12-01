#include FcnLib.ahk

ph=C:\
iron=\\iron\c$\

file1=Inetpub\epms\view\html\user.tt
file2=Inetpub\EPMS\EPMS\Schema\Result\User.pm
file3=Inetpub\epms\view\js\EPMS\ui\grid\Users.js
file4=Inetpub\epms\view\js\EPMS\record\Users.js
file5=Inetpub\epms\Controller\User.pm

Loop 5
{
   filename:=file%A_Index%
   FileCopy, %ph%%filename%, %iron%%filename%, 1
}
