#include FcnLib.ahk

libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-05-05.csv"
;libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-09-01.csv"
libFile="C:\My Dropbox\Android\sd\Documents\Financial\USAA Accounts\usaa_credit-2010-11-18.csv"
RunAhk("RegExFileProcessor.ahk", libFile)
;RunAhk("RemoteWidget.ahk")
;RunAhk("Intellisense2.ahk")
