; Testing the mDump Macro       (TestDump.asm)

; This program demonstrates the mDump macro

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
one    BYTE  "ABCDEFG"
two    WORD  10h,20h,30h,40h,50h,60h
three  DWORD 20000h,30000h,40000h

.code
main PROC

	mDump one, Y		; display variable name
	mDump two			; don't display name
	mDump three, Y		; display name

	exit
main ENDP
END main