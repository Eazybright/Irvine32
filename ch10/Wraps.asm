; Procedure Wrapper Macros        (Wraps.asm)

; This program demonstrates macros as wrappers
; for library procedures. Contents: mGotoxy, mWrite,
; mWriteString, mReadString, and mDumpMem.

INCLUDE Irvine32.inc
INCLUDE Macros.inc			; macro definitions

.data
array DWORD 1,2,3,4,5,6,7,8
firstName BYTE 31 DUP(?)
lastName  BYTE 31 DUP(?)

.code
main PROC
	mGotoxy 0,0
	mWrite <"Sample Macro Program",0dh,0ah>

; Input the user’s name.
	mGotoxy 0,5
	mWrite "Please enter your first name: "
	mReadString firstName
	call Crlf

	mWrite "Please enter your last name: "
	mReadString lastName
	call Crlf

; Display the user’s name.
	mWrite "Your name is "
	mWriteString firstName
	mWriteSpace
	mWriteString lastName
	call Crlf

; Display the array of integers.
	mDumpMem OFFSET array,LENGTHOF array, TYPE array
	exit
main ENDP

END main