#include FcnLib.ahk
#include thirdParty\json.ahk

;figuring out how to make nice loops through firefly fees

feesJson := FileRead(GetPath("FireflyFees.json"))
listFees := json(feesJson, "listFees")
Loop, parse, listFees, CSV
{
   thisFee:=A_LoopField
   ;i:=A_Index
   ;thisFeeAmount:=FeeAmount%i%
   thisFeeType := json(feesJson, thisFee . ".type")
   ;AddFees(thisFeeType, thisFee, i)
   debug(thisFee, thisFeeType)
}
