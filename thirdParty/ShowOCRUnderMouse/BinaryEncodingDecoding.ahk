/*
BinaryEncodingDecoding.ahk

Routines to encode and decode binary data to and from Ascii/Ansi data (source code).

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.01.000 -- 2006/07/04 (PL) -- Finally, I put Pebwa in its own file, it has less generic use.
 1.00.000 -- 2006/03/29 (PL) -- Creation, taking Bin2Hex and Hex2Bin
          (and Bin2Pebwa & Pebwa2Bin) from DllCallStruct.

Bin2Hex & Hex2Bin derivated from Laszlo's code.
*/
/* Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2006 Philippe Lhoste / PhiLhoSoft
*/

FormatHexNumber(_value, _digitNb)
{
	local hex, intFormat

	; Save original integer format
	intFormat := A_FormatInteger
	; For converting bytes to hex
	SetFormat Integer, Hex

	hex := _value + (1 << 4 * _digitNb)
	StringRight hex, hex, _digitNb
	; I prefer my hex numbers to be in upper case
	StringUpper hex, hex

	; Restore original integer format
	SetFormat Integer, %intFormat%

	Return hex
}

/*
// Convert raw bytes stored in a variable to a string of hexa digit pairs.
// Convert either byteNb bytes or, if null, the whole content of the variable.
//
// Return the number of converted bytes, or -1 if error (memory allocation)
*/
Bin2Hex(ByRef @hexString, ByRef @bin, _byteNb=0)
{
	local dataSize, dataAddress, granted, hex

	; Get size of data
	dataSize := VarSetCapacity(@bin)
	If (_byteNb < 1 or _byteNb > dataSize)
	{
		_byteNb := dataSize
	}
	dataAddress := &@bin
	; Make enough room (faster)
	granted := VarSetCapacity(@hexString, _byteNb * 2)
	if (granted < _byteNb * 2)
	{
		; Cannot allocate enough memory
		ErrorLevel = Mem=%granted%
		Return -1
	}
	Loop %_byteNb%
	{
		; Get byte in hexa
		hex := FormatHexNumber(*dataAddress, 2)
		@hexString = %@hexString%%hex%
		dataAddress++	; Next byte
	}

	Return _byteNb
}

/*
// Convert a string of hexa digit pairs to raw bytes stored in a variable.
// Convert either byteNb bytes or, if null, the whole content of the variable.
//
// Return the number of converted bytes, or -1 if error (memory allocation)
*/
Hex2Bin(ByRef @bin, _hex, _byteNb=0)
{
	local dataSize, granted, dataAddress, x

	; Get size of data
	x := StrLen(_hex)
	dataSize := x // 2
	if (x = 0 or dataSize * 2 != x)
	{
		; Invalid string, empty or odd number of digits
		ErrorLevel = Param
		Return -1
	}
	If (_byteNb < 1 or _byteNb > dataSize)
	{
		_byteNb := dataSize
	}
	; Make enough room
	granted := VarSetCapacity(@bin, _byteNb, 0)
	if (granted < _byteNb)
	{
		; Cannot allocate enough memory
		ErrorLevel = Mem=%granted%
		Return -1
	}
	dataAddress := &@bin

	Loop Parse, _hex
	{
		if (A_Index & 1 = 1)	; Odd
		{
			x := A_LoopField	; Odd digit
		}
		Else
		{
			; Concatenate previous x and even digit, converted to hex
			x := "0x" . x . A_LoopField
			; Store integer in memory
			DllCall("RtlFillMemory"
					, "UInt", dataAddress
					, "UInt", 1
					, "UChar", x)
			dataAddress++
		}
	}

	Return _byteNb
}
