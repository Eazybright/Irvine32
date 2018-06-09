; Scanning an Array              (ArryScan.asm)

; Scan an array for the first nonzero value.

INCLUDE Irvine32.inc

.data
intArray SWORD  0,0,0,0,1,20,35,-12,66,4,0
;intArray SWORD  1,0,0,0
;intArray SWORD  0,0,0,0
;intArray SWORD  0,0,0,1
noneMsg  BYTE "A non-zero value was not found",0

.code
main PROC
	mov   ebx,OFFSET intArray		; point to the array
	mov   ecx,LENGTHOF intArray		; loop counter

L1:
	cmp   WORD PTR [ebx],0		; compare value to zero
	jnz   found				; found a value
	add   ebx,2				; point to next
	loop  L1					; continue the loop
	jmp   notFound				; none found

found:
	movsx eax,WORD PTR [ebx]		; otherwise, display it
	call  WriteInt
	jmp   quit

notFound:
	mov   edx,OFFSET noneMsg		; display "not found" message
	call  WriteString

quit:
	call  crlf
	exit
main ENDP
END main