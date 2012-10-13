#include FcnLib.ahk

;Heck yeah, race reminders

Loop
{
   url := GetUrlBar("firefox")
   if ( ProcessExist("iRacingSim.exe") OR InStr(url, "iracing.com") )
   {
      hourly   := true
      legends  := true
      inRacing := true
      ;specRF   := true
      ;cadillac := true

      ;Miata Cup Races (Stock Races, too)
      i=0
      if hourly
      Loop 24
      {
         ;ALL
         DingIfScheduled(i, 58)
         i++
      }

      ;Legends Races
      i=0
      if legends
      Loop 24
      {
         if (Mod(i, 2)==1) ;ODD
            DingIfScheduled(i, 28)
         i++
      }

      ;MC Solstice/Miata Races
      i=0
      if inRacing
      Loop 24
      {
         if (Mod(i, 2)==0) ;EVEN
            DingIfScheduled(i, 28)
         i++
      }

      ;SRF Races
      i=0
      if specRF
      Loop 24
      {
         if (Mod(i, 2)==1) ;ODD
            DingIfScheduled(i, 43)
         i++
      }

      ;Cadillac Cup Races
      i=0
      if cadillac
      Loop 24
      {
         if (Mod(i, 2)==1) ;ODD
            DingIfScheduled(i, 28)
         i++
      }

      ;DingIfScheduled(0, 59)
      ;DingIfScheduled(1, 59)
      ;DingIfScheduled(2, 59)
      ;...
      ;DingIfScheduled(23, 59)

      ;DingIfScheduled(0, 29)
      ;DingIfScheduled(2, 29)
      ;...
      ;DingIfScheduled(22, 29)
   }
   SleepSeconds(5)
}
ExitApp

Ding(times=1)
{
   SoundPlay, %A_WinDir%\Media\ding.wav
   Sleep, 100
   if (times == 2)
      SoundPlay, %A_WinDir%\Media\ding.wav
   Sleep, 5000
}

DingIfScheduled(hour2, min2)
{
   hour1 := hour2
   min1 := min2 - 4

   ;check time
   ;play sound
   if (A_Hour=hour1 AND A_Min=min1)
   {
      Ding()
      SleepMinutes(1)
   }
   if (A_Hour=hour2 AND A_Min=min2)
   {
      Ding(2)
      SleepMinutes(1)
   }
}
