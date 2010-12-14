#include FcnLib.ahk

;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-05-05.csv"
;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-09-01.csv"
;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"
libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"

in ="C:\My Dropbox\AHKs-GitExempt\USAA_credit_2010-12-09_21-15-59.csv"
re ="C:\My Dropbox\ahk-REFP\regex-financial.txt"
out="C:\My Dropbox\AHKs-GitExempt\USAA_credit_2010-12-09_21-15-59-category.csv"

params:=concatWithSep(" ", in, re, out)
RunAhk("RegExFileProcessor.ahk", params)
;RunAhk("RemoteWidget.ahk")
;RunAhk("Intellisense2.ahk")
