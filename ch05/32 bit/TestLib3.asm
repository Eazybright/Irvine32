; Link Library Test #3		(TestLib3.asm)

; Calculate the elapsed execution time of a nested loop

INCLUDE Irvine32.inc

.data
OUTER_LOOP_COUNT = 3
startTime DWORD ?
msg1 BYTE "Please wait...",0dh,0ah,0
msg2 BYTE "Elapsed milliseconds: ",0

.code
main PROC
	mov	edx,OFFSET msg1     ; "Please wait..."
	call	WriteString

; Save the starting time

	call	GetMSeconds
	mov	startTime,eax
	
; Start the outer loop

	mov	ecx,OUTER_LOOP_COUNT 	
	
L1:	call	innerLoop
	loop	L1

; Calculate the elapsed time

	call	GetMSeconds
	sub	eax,startTime
	
; Display the elapsed time
	
	mov	edx,OFFSET msg2     ; "Elapsed milliseconds: "
	call	WriteString
	call	WriteDec            ; write the milliseconds
	call	Crlf
	
	exit
main ENDP

innerLoop PROC
	push	ecx                 ; save current ECX value
	
	mov	ecx,0FFFFFFFh       ; set the loop counter
L1:	mul  eax                 ; eat up some cylces
     mul  eax
     mul  eax
	loop	L1                  ; repeat the inner loop
	
	pop	ecx                 ; restore ECX's saved value
	ret
innerLoop ENDP

END main