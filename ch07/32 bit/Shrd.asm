; SHRD Example             (Shrd.asm)

Comment !
This program shifts an array of five 32-bit integers using the SHRD 
instruction. It shifts a series of consecutive doublewords 4 bits 
to the right. The number is in little Endian order.
!

INCLUDE Irvine32.inc

COUNT = 4				; shift count

.data
array DWORD 648B2165h,8C943A29h,6DFA4B86h,91F76C04h,8BAF9857h

.code
main PROC

	mov  bl,COUNT
	call ShiftDoublewords

; Display the results
	mov  esi,OFFSET array
	mov  ecx,LENGTHOF array
	mov  ebx,TYPE array
	call DumpMem

	exit
main ENDP

;---------------------------------------------------------------
ShiftDoublewords PROC
;
; Shifts an array of doublewords to the right.
; The array is a global variable.
; Receives: BL = number of bits to shift
; Returns: nothing
;---------------------------------------------------------------
	mov  esi,OFFSET array
	mov  ecx,(LENGTHOF array) - 1

L1:	push ecx				; save loop counter
	mov  eax,[esi + TYPE DWORD]
	mov  cl,bl				; shift count
	shrd [esi],eax,cl			; shift EAX into high bits of [esi]
	add  esi,TYPE DWORD			; point to next doubleword pair
	pop  ecx					; restore loop counter
	loop L1

; Right-shift the last doubleword
	shr DWORD PTR [esi],COUNT

	ret
ShiftDoublewords ENDP

END main