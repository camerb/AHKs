#include FcnLib.ahk

ping:=urldownloadtovar("http://www.usaa.com/")

if NOT ping
   debug("no response")
else
   debug("yup, it's up")
