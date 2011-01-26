#include FcnLib.ahk
#include ThirdParty/CmdRet.ahk

joe:=CmdRet_RunReturn("cpan-outdated | cpanm")
debug(joe)
