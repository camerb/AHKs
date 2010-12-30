#include FcnLib.ahk

;process the csv for the usaa credit card and add categories to it

;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-05-05.csv"
;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-09-01.csv"
;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"
libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"

in ="C:\My Dropbox\AHKs-GitExempt\USAA_credit_2010-12-09_21-15-59.csv"
re ="C:\My Dropbox\ahk-REFP\regex-financial.txt"
out="C:\My Dropbox\AHKs-GitExempt\USAA_credit_2010-12-09_21-15-59-category.csv"

in ="C:\My Dropbox\AHKs-GitExempt\USAA_checking_2010-12-24_08-03-41.csv"
re ="C:\My Dropbox\ahk-REFP\regex-financial-checking.txt"
out="C:\My Dropbox\AHKs-GitExempt\USAA_checking_2010-12-24_08-03-41-category.csv"

in ="C:\My Dropbox\Mgmt-IDs-Merge.csv"
re ="C:\My Dropbox\ahk-REFP\regex1.txt"
out="C:\My Dropbox\Mgmt-IDs-Merge7.bat"

params:=concatWithSep(" ", in, re, out)
;params:=in
RunAhk("RegExFileProcessor.ahk", params)
;RunAhk("RemoteWidget.ahk")
;RunAhk("Intellisense2.ahk")
