; IF statements             (IfStatements.asm)

; Implementations of IF statements

INCLUDE Irvine32.inc

.data
X	DWORD ?
Y	DWORD ?
op1	DWORD ?
op2	DWORD ?

.code
main PROC

	call example_3

	exit
main ENDP

;----------------------------------------------------
example_3 PROC

COMMENT @
if op1 > op2 then
	call Routine1
else
	call Routine2
end if
@

; Version 1:
	mov	eax,op1
	cmp	eax,op2	; op1 > op2?
	jg	B1		; yes: call Routine1
	call	Routine2	; no: call Routine2
	jmp	B2
B1:	call	Routine1
B2:

; Version 2:
	mov	eax,op1
	cmp	eax,op2	; op1 > op2?
	jng	A1		; no: call Routine2
	call	Routine1	; yes: call Routine1
	jmp	A2	
A1:	call	Routine2
A2:

	ret
example_3 ENDP


example_4 PROC

COMMENT @
if op1 == op2 then
  if X > Y then
	call	Routine1
  else
    call	Routine2
  end if
else
  call Routine3
end if
@

	mov	eax,op1
	cmp	eax,op2	; op1 == op2?
	jne	L2		; no: call Routine3
; process the inner IF statement.
	mov	eax,X
	cmp	eax,Y	; X > Y?
	jg	L1		; yes: call Routine1
	call	Routine2	; no: call Routine2
	jmp	L3		; and exit

L1:	call	Routine1	; call Routine1
	jmp	L3		; and exit

L2:	call	Routine3
L3:

	ret
example_4 ENDP

compound_and_nss PROC
; implements: if al > bl and bl > cl then X = 1
; using unsigned values, no short-circuit evaluation.
.data
temp BYTE ?
.code
	mov	temp,0
	cmp	al,bl	; AL > BL?
	jna	L1		; no
	mov	temp,1	; yes: set true flag
	
L1:	cmp	bl,cl	; BL > CL?
	jna	L2		; no
	mov	temp,1	; yes: set true flag

L2:	cmp	temp,1	; flag equal to true?
	jne	next
	mov	X,1
next:
	ret
compound_and_nss ENDP


;----------------------------------------------------
Routine1 proc
	ret
Routine1 endp

Routine2 proc
	ret
Routine2 endp

Routine3 proc
	ret
Routine3 endp

END main