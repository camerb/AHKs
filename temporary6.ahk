#include FcnLib.ahk

foo := CurrentTime()
;debug(foo)

foo += 2, days
;debug(foo)

foo += 19, days
;debug(foo)

foo += 2, months
;debug(foo)



var1 = 20060126
var2 = 20050126
EnvSub, var1, %var2%, days
debug(var1)

var1 = 20050126
var2 = 20040126
EnvSub, var1, %var2%, days
debug(var1)
