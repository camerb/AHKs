#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;log in to the va vpn

WhichVA := Prompt("Which VA are you logging into?`n(Type 'skip' to skip sending a notification)")
if (WhichVA == "ERROR")
   ExitApp

;if NOT RegExMatch(WhichVA, "^(ERROR|skip)$")
if (WhichVA != "skip")
{
   subject=Logging in to VA VPN
   message=Just FYI: I'm opening up a VPN connection now to look at VA %WhichVA%
   ;debug("", subject, message)
   SendEmail(subject, message, "", "jason@mitsi.com", "cameron@mitsi.com")
}
;debug("end")
;return

us:=SexPanther("lynx-vpn-user")
joe:=SexPanther("lynx-vpn-pass")
imacro=
(
TAB CLOSEALLOTHERS
URL GOTO=https://vareast.vpn.va.gov/vpn/index.html
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:vpnForm ATTR=NAME:login CONTENT=%us%
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:vpnForm ATTR=NAME:passwd CONTENT=%joe%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=NAME:vpnForm ATTR=VALUE:Logon
REFRESH
TAG POS=1 TYPE=A ATTR=ID:Desktops_Text
TAG POS=1 TYPE=DIV ATTR=ID:desktopSpinner_idCitrix.MPS.Desktop.R04_0020Citrix_0020Farm.Full_0020Desktop
TAG POS=1 TYPE=DIV ATTR=ID:selectedTabContent
)

RunIMacro(imacro)
