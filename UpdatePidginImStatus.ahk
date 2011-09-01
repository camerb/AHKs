#include FcnLib.ahk
#include thirdParty/TF.ahk

ProcessCloseAll("pidgin.exe")

FileRead, statusText, C:\Dropbox\Android\sd\imStatus.txt
statusText:=RegExReplace(statusText, "(`r|`n)", " ")
statusText:=RegExReplace(statusText, " +", " ")
;statusText=Nyan Cat

;statusText:=StringReplace(statusText, "'", "\'")

accountsFile=!C:\Users\cameron\AppData\Roaming\.purple\accounts.xml
statusFile=C:\Users\cameron\AppData\Roaming\.purple\status.xml
xml =
(
<?xml version='1.0' encoding='UTF-8' ?>

<statuses version='1.0'>
	<status name='Auto-Cached' transient='true' created='1310160287' lastused='1310482367' usage_count='2'>
		<state>available</state>
		<message>%statusText%</message>
	</status>
</statuses>
)

statusText:=StringReplace(statusText, "'", "''")

accountsXml=
(
			<status type='available' name='Available' active='true'>
				<attributes>
					<attribute id='message' value='%statusText%'/>
				</attributes>
			</status>
)
;debug(xml)
FileCreate(xml, statusFile)
TF_RegExReplace(accountsFile, "<status type='.* active='true'>.*?status>", accountsXml)
;Sleep, 500
SleepSeconds(20)

RunProgram("C:\Program Files (x86)\Pidgin\pidgin.exe")
while NOT ForceWinFocusIfExist("Buddy List ahk_class gdkWindowToplevel")
{
   RunProgram("C:\Program Files (x86)\Pidgin\pidgin.exe")
   Sleep, 100
   count++
   if (count > 1000)
      fatalErrord("silent log", "the pidgin window never activated", A_ScriptName, A_LineNumber)
}
SleepSeconds(10)

;ForceWinFocus("Buddy List ahk_class gdkWindowToplevel")
;WinGetPos, no, no, width, height
;Click(width/2, height-20, "Click")

;Send, ^a
;Sleep, 100

;Send, {DEL}
;Sleep, 100

;FileRead, statusText, C:\Dropbox\Android\sd\imStatus.txt
;statusText:=RegExReplace(statusText, "(`r|`n)", " ")
;statusText:=RegExReplace(statusText, " +", " ")
;SendViaClipboard(statusText)

;Sleep, 2000

WinClose, Buddy List ahk_class gdkWindowToplevel
