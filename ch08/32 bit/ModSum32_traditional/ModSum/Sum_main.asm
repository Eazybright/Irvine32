; Integer Summation Program		 (Sum_main.asm)

; Multimodule example:   (main module)
; This program inputs multiple integers from the user,
; stores them in an array, calculates the sum of the
; array, and displays the sum.

; Uses EXTERN to access external procedures

INCLUDE Irvine32.inc

EXTERN PromptForIntegers@0:PROC
EXTERN ArraySum@0:PROC, DisplaySum@0:PROC

; Redefine external symbols for convenience
ArraySum			EQU ArraySum@0
PromptForIntegers	EQU PromptForIntegers@0
DisplaySum		EQU DisplaySum@0

; modify Count to change the size of the array:
Count = 3

.data
prompt1 BYTE  "Enter a signed integer: ",0
prompt2 BYTE  "The sum of the integers is: ",0
array   DWORD  Count DUP(?)
sum     DWORD  ?

.code
main PROC
	call	Clrscr

; PromptForIntegers( addr prompt1, addr array, Count )
	push	Count
	push	OFFSET array
	push	OFFSET prompt1
	call	PromptForIntegers

; eax = ArraySum( addr array, Count )
	push	Count
	push	OFFSET array
	call	ArraySum
	mov	sum,eax

; DisplaySum( addr prompt2, sum )
	push	sum
	push	OFFSET prompt2
	call	DisplaySum

	call	Crlf
	exit
main ENDP

END main