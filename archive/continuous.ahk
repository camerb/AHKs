while true
{
;SetTitleMatchMode 1

WinWait, DocumentationTextEditor - Microsoft Visual C# 2008 Express Edition (Administrator), 
IfWinNotActive, DocumentationTextEditor - Microsoft Visual C# 2008 Express Edition (Administrator), , WinActivate, DocumentationTextEditor - Microsoft Visual C# 2008 Express Edition (Administrator), 
WinWaitActive, DocumentationTextEditor - Microsoft Visual C# 2008 Express Edition (Administrator), 
MouseClick, left,  554,  237
Sleep, 3*60*1000
MouseClick, left,  559,  266
Sleep, 3*60*1000

Send, {ALTDOWN}{TAB}{ALTUP}
MouseClick, left,  480,  22
Sleep, 3*60*1000
MouseClick, left,  129,  126
Sleep, 3*60*1000
WinWait, SBIR/STTR Topics : Small Business...Innovation Research...Technology Transfer : DoD Solicitations - Mozilla Firefox, 
IfWinNotActive, SBIR/STTR Topics : Small Business...Innovation Research...Technology Transfer : DoD Solicitations - Mozilla Firefox, , WinActivate, SBIR/STTR Topics : Small Business...Innovation Research...Technology Transfer : DoD Solicitations - Mozilla Firefox, 
WinWaitActive, SBIR/STTR Topics : Small Business...Innovation Research...Technology Transfer : DoD Solicitations - Mozilla Firefox, 
MouseClick, left,  218,  126
Sleep, 3*60*1000
WinWait, frazzoli.pdf (application/pdf Object) - Mozilla Firefox, 
IfWinNotActive, frazzoli.pdf (application/pdf Object) - Mozilla Firefox, , WinActivate, frazzoli.pdf (application/pdf Object) - Mozilla Firefox, 
WinWaitActive, frazzoli.pdf (application/pdf Object) - Mozilla Firefox, 
MouseClick, left,  399,  119
Sleep, 3*60*1000
WinWait, cdcMCPP.pdf (application/pdf Object) - Mozilla Firefox, 
IfWinNotActive, cdcMCPP.pdf (application/pdf Object) - Mozilla Firefox, , WinActivate, cdcMCPP.pdf (application/pdf Object) - Mozilla Firefox, 
WinWaitActive, cdcMCPP.pdf (application/pdf Object) - Mozilla Firefox, 
MouseClick, left,  575,  121
Sleep, 3*60*1000
WinWait, Department of Defense: SBIR/STTR/Fast Track - Sample Proposals - Mozilla Firefox, 
IfWinNotActive, Department of Defense: SBIR/STTR/Fast Track - Sample Proposals - Mozilla Firefox, , WinActivate, Department of Defense: SBIR/STTR/Fast Track - Sample Proposals - Mozilla Firefox, 
WinWaitActive, Department of Defense: SBIR/STTR/Fast Track - Sample Proposals - Mozilla Firefox, 
MouseClick, left,  701,  122
Sleep, 3*60*1000
WinWait, SBIR Proposal Writing Basics - Mozilla Firefox, 
IfWinNotActive, SBIR Proposal Writing Basics - Mozilla Firefox, , WinActivate, SBIR Proposal Writing Basics - Mozilla Firefox, 
WinWaitActive, SBIR Proposal Writing Basics - Mozilla Firefox, 
MouseClick, left,  880,  124
Sleep, 3*60*1000



}
