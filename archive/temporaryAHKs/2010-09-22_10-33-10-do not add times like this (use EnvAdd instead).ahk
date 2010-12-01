#include FcnLib.ahk

foobar := prompt("Give me the first date:")

StringLeft, month, foobar, 2
StringTrimLeft, rest, foobar, 2
month += 9
foobar=%month%%rest%
msgbox, Nine months from the date you specified is %foobar%

;use EnvAdd instead of this crappy method
