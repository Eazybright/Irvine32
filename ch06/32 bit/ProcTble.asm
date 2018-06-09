; Table of Procedure Offsets          (ProcTble.asm)

; This progam contains a table with offsets of procedures.
; It uses the table to execute indirect procedure calls.

INCLUDE Irvine32.inc
.data
CaseTable  BYTE   'A'			; lookup value
           DWORD   Process_A		; address of procedure
           BYTE   'B'
           DWORD   Process_B
           BYTE   'C'
           DWORD   Process_C
           BYTE   'D'
           DWORD   Process_D
NumberOfEntries = 4

prompt BYTE "Press capital A,B,C,or D: ",0
msgA BYTE "Process_A",0
msgB BYTE "Process_B",0
msgC BYTE "Process_C",0
msgD BYTE "Process_D",0

.code
main PROC
	mov  edx,OFFSET prompt		; ask user for input
	call WriteString
	call ReadChar				; read one character
	mov  ebx,OFFSET CaseTable	; point EBX to the table
	mov  ecx,NumberOfEntries 	; loop counter
L1:
	cmp  al,[ebx]				; match found?
	jne  L2					; no: continue
	call NEAR PTR [ebx + 1]		; yes: call the procedure
	call WriteString			; display message
	call Crlf
	jmp  L3					; exit the search
L2:
	add  ebx,5				; point to the next entry
	loop L1					; repeat until ECX = 0

L3:
	exit
main ENDP

Process_A PROC
	mov  edx,OFFSET msgA
	ret
Process_A ENDP

Process_B PROC
	mov  edx,OFFSET msgB
	ret
Process_B ENDP

Process_C PROC
	mov  edx,OFFSET msgC
	ret
Process_C ENDP

Process_D PROC
	mov  edx,OFFSET msgD
	ret
Process_D ENDP

END main