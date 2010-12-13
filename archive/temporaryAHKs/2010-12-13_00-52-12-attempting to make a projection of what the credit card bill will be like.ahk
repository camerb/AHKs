#include FcnLib.ahk


FormatTime, currentDay, , dd
daysThruBillingPeriod := mod( currentDay - 22 + 31, 31 )
percentThru := daysThruBillingPeriod / 31 * 100
percentLeft := 100 - percentThru
spentPerPercent := CreditBalance / percentThru
projectedCreditCardBill := CreditBalance + percentLeft * spentPerPercent
debug("silent log green line", currentDay, daysThruBillingPeriod, percentThru, percentLeft, spentPerPercent, projectedCreditCardBill)
