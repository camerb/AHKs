#include FcnLib.ahk

AddFees("Client", "Pinellas County Sticker", 3)
AddFees("Client", "Pinellas County Sticker", 3)
AddFees("Client", "Pinellas County Sticker", 3)
AddFees("Client", "Pinellas County Sticker", 3)

AddFees(type, name, amount)
{
ForceWinFocus("Status Pro", "RegEx")
dist:=93
WFCIImageSearch("images/firefly/fees/feesButton.bmp")
Sleep, 5000
WaitForImageSearch("images/firefly/fees/addNewFee.bmp", 60)
ClickIfImageSearch("images/firefly/fees/addNewFee.bmp")
ClickIfImageSearch("images/firefly/fees/addNewFee2.bmp")
ClickIfImageSearch("images/firefly/fees/addNewFee2.bmp")
ClickIfImageSearch("images/firefly/fees/addNewFee3.bmp")
ClickIfImageSearch("images/firefly/fees/addNewFee4.bmp")
MouseMove, 5, 5, , R
Click
WFCIImageSearch("images/firefly/fees/feeGroupField.bmp")
MouseMove, %dist%, 5, , R
Click
Send, ^a
Send, %type%
Sleep, 1000
WFCIImageSearch("images/firefly/fees/feeDescriptionField.bmp") ;this one is a little farther to the right
Sleep, 5000
MouseMove, %dist%, 5, , R
Click
Send, ^a
Send, %name%
Sleep, 4000
WFCIImageSearch("images/firefly/fees/feeAmountField.bmp")
MouseMove, %dist%, 5, , R
Click
Send, ^a
Send, %amount%
Sleep, 2000
WFCIImageSearch("images/firefly/fees/save.bmp")
Sleep, 2000
WFCIImageSearch("images/firefly/fees/feesClose.bmp")
Sleep, 5000
}



ExitApp
;;;;; USING THIS AS A LIB
#include fireflyButtons.ahk

/*


Reference #  2522980
Fee Group	Fee Description	Amount	Qty	Sales Tax	Total	Export Status	GP Import Date	Invoice #	Payee	Vendor Invoice	Override	PrePayment	PrePayment Check #
Add new record
1
Page size:
	select

    * 10
    * 20
    * 50

 4 items in 1 pages
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0

*/
