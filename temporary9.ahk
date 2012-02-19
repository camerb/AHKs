#include FcnLib.ahk
#include Firefly-FcnLib.ahk


iniFolder:=GetPath("FireflyIniFolder")
joe := IniFolderlistallkeys(inifolder, "Status")
;joe := IniFolderlistallsections(inifolder)
debug(joe)
