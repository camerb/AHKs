#include FcnLib.ahk

;process the csv for the usaa credit card and add categories to it

;libFile="C:\Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-05-05.csv"
;libFile="C:\Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-09-01.csv"
;libFile="C:\Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"
libFile="C:\Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"

in ="C:\Dropbox\AHKs\gitExempt\USAA_credit_2010-12-09_21-15-59.csv"
re ="C:\Dropbox\AHKs\REFP\regex-financial.txt"
out="C:\Dropbox\AHKs\gitExempt\USAA_credit_2010-12-09_21-15-59-category.csv"

in ="C:\Dropbox\AHKs\gitExempt\USAA_checking_2010-12-24_08-03-41.csv"
re ="C:\Dropbox\AHKs\REFP\regex-financial-checking.txt"
out="C:\Dropbox\AHKs\gitExempt\USAA_checking_2010-12-24_08-03-41-category.csv"

in ="C:\Dropbox\Mgmt-IDs-Merge.csv"
re ="C:\Dropbox\AHKs\REFP\regex2.txt"
out="C:\Dropbox\Mgmt-IDs-Merge8-propcleanup.bat"

in ="C:\Dropbox\AHKs\gitExempt\mint_export\2011-01-06_03-29-31.csv"
re ="C:\Dropbox\AHKs\REFP\regex-mint.txt"

;REFP(in, re, out)
REFP(in, re, "")
;params:=in
;RunAhk("RegExFileProcessor.ahk", params)
;RunAhk("RemoteWidget.ahk")
;RunAhk("Intellisense2.ahk")
