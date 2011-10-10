#include FcnLib.ahk
#include FcnLib-Nightly.ahk

addtotrace("hello from " . A_ComputerName)

url=http://dl.dropbox.com/u/789954/knowntitle.html
imacro=
(
URL GOTO=%url%
)

RunIMacro(imacro)
result := GetFirefoxPageSource()
expected := UrlDownloadToVar(url)
addtotrace(result)
if (result != expected)
   errord("", "GetFirefoxPageSource() does not work right", expected, result)

