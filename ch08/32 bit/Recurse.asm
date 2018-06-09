; Indirect Recursion                (Recurse.asm)

; Demonstration of the kind of indirect recursion that
; beginning programmers often use to avoid writing
; a loop. As each call to ShowMenu occurs, it pushes
; multiple return addresses onto the stack, which
; must later be unwound before control returns to main.

INCLUDE Irvine32.inc

.data
menuStr  BYTE "1. Choice one",0dh,0ah
	    BYTE "2. Choice two",0dh,0ah
	    BYTE "3. Exit",0dh,0ah,0dh,0ah
	    BYTE "Choice: ",0
	    
OneStr  BYTE "Executing Choice One",0dh,0ah,0
TwoStr  BYTE "Executing Choice Two",0dh,0ah,0
leavingMsg BYTE "Leaving ShowMenu",0dh,0ah,0

.code
main PROC
	call ShowMenu
	exit
main ENDP

ShowMenu PROC
	call DumpRegs			; register dump

	mov  edx,OFFSET menuStr	; display menu
	call WriteString
	call ReadInt
	call Dispatcher

	mov  edx,OFFSET leavingMsg	; "leaving ShowMenu"
	call WriteString
	ret
ShowMenu endp

Dispatcher proc
	cmp  eax,1	; choice 1?
	jne  L1
	call ChoiceOne
L1:
	cmp  eax,2	; choice 2?
	jne  L2
	call ChoiceTwo
L2:
	cmp  eax,3	; choice 3?
	je   L3
	call ShowMenu	; unknown choice

; start unwinding the stack
L3:	ret
Dispatcher endp

ChoiceOne PROC		; menu choice 1
	mov edx,OFFSET OneStr
	call WriteString
	call WaitMsg
	call ShowMenu	; recursive call
	ret
ChoiceOne endp

ChoiceTwo proc		; menu choice 2
	mov edx,OFFSET TwoStr
	call WriteString
	call WaitMsg
	call ShowMenu	; recursive call
	ret
ChoiceTwo endp

END main