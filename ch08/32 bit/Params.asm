; Procedure Parameter Examples          (Params.asm)

; This program demonstrates the use of the PROC, 
; PROTO, and INVOKE directives.

INCLUDE Irvine32.inc

Sub1 PROTO someData:WORD
Sub2 PROTO dataPtr:PTR WORD

ArraySum PROTO,
	ptrArray:PTR DWORD,
	szArray:DWORD

AddThree PROTO,
	val1:DWORD,
	val2:DWORD,
	val3:DWORD

FillArray PROTO,
	pArray:PTR BYTE

.data
myData WORD 1000h
theSum DWORD  ?


bArray BYTE 30 dup(0)
wArray WORD 30 dup(0)
dArray  DWORD  10000h,20000h,30000h,40000h,50000h

.code
main PROC

	push	5
	call	Simple

	INVOKE Sub2, ADDR myData		; pass by reference

	INVOKE Sub2, ADDR dArray		; wrong type of pointer!

	INVOKE Sub1, myData			; pass by value

; Pass variables as input parameters:

	INVOKE ArraySum,
	    ADDR dArray,		; addr of the array
	    LENGTHOF dArray		; size of the array
	mov theSum,eax			; returned in EAX
	call WriteHex			; display the sum
	call Crlf

; Pass registers as input parameters:

	mov ecx,OFFSET dArray
	mov esi,LENGTHOF dArray
	INVOKE ArraySum,ecx,esi

; Demonstrate various parameter types:

	INVOKE FillArray, ADDR bArray		; preferred
	INVOKE FillArray, OFFSET bArray	; also works

	INVOKE ExitProcess,0
main ENDP


Simple PROC uses EAX EBX
	push	ebp
	mov	ebp,esp

	mov	eax,[ebp+8]				; doesn't get the parameter

	ret
Simple ENDP


; Demonstrates procedure parameters combined
; with local variables and USES clause:

Read_File PROC USES eax ebx,
	pBuffer:PTR BYTE
	LOCAL fileHandle:DWORD
	
	mov	esi,pBuffer
	mov	fileHandle,eax
	
	
	ret
Read_File ENDP


;simple example, showing how parameters are
;converted into code by MASM

AddTwo PROC, 
	val1:DWORD, 
	val2:DWORD

	mov	eax,val1
	add	eax,val2

	ret
AddTwo ENDP


;-----------------------------------------------------
; In a PROC definition, the USES clause must be on
; the same line as PROC. The parameter list can be on
; one or more separate lines, as long as there is a
; comma at the end of the first line:
;-----------------------------------------------------

;-----------------------------------------------------
ArraySum PROC USES esi ecx,
	ptrArray:PTR DWORD, 	; points to the array
	szArray:DWORD	; array size
;
; Calculates the sum of an array of 32-bit integers.
; Returns:  EAX = sum of the array elements
;-----------------------------------------------------
	mov   esi,ptrArray		; address of the array
	mov   ecx,szArray		; size of the array
	mov   eax,0			; set the sum to zero
AS1:
	add   eax,[esi]		; add each integer to sum
	add   esi,4			; point to next integer
	loop  AS1				; repeat for array size

	ret					; sum is in EAX
ArraySum ENDP

Sub1 PROC someData:WORD
	mov someData,0
	ret
Sub1 ENDP

Sub2 PROC dataPtr:PTR WORD
	lea eax,dataPtr		; address of stack parameter
	;mov eax,OFFSET dataPtr	; intentional error

	mov esi,dataPtr		; address of the array
	mov WORD PTR[esi],0		; dereference, assign zero
	ret
Sub2 ENDP

AddThree PROC val1:DWORD, val2:DWORD, val3:DWORD

	ret
AddThree ENDP

FillArray PROC,
	pArray:PTR BYTE

	ret
FillArray ENDP

ShowArray PROC,
	pArray:NEAR32

	ret
ShowArray ENDP

END main