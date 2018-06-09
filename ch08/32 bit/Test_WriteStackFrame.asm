 ; Tests WriteStackFrame and WriteStackFrameName  (StackFrameExample.asm)

; This program tests the WriteStackFrame and WriteStackFrameName procedures
; from the Irvine32 library. It uses both "highlevel" and hand coded procedures

; Contributed by James Brink, Pacific Lutheran University, April 6, 2005.

INCLUDE Irvine32.inc
INCLUDE macros.inc

aProc PROTO,
           x: DWORD,
           y: DWORD

bProc PROTO

dProc PROTO, x: DWORD

.code
main PROC
    ; set values to registers that will be saved by the procedures
   	mov ecx, 0ECECECECh
   	mov edx, 0EDEDEDEDh
   	
	; Set some register values that we can recognize later.
   	mov eax, 0EAEAEAEAh
   	mov ebx, 0EBEBEBEBh
	INVOKE aProc, 1111h, 2222h	; pass X and Y
	
	; call procedure with 0 parameters
	call bProc
	
	; writeStackFrameName does not work in cProc because it has only
    ; a USES clause
	call cProc
	
	; writeStackFrame us ed in a procedure that has 1 parameter
	INVOKE dProc, 1111h

	; writeStackFrameName used in a procedure that has 1 local variable
	call eProc

	; call a hand coded procedure
	push 4444h
	push 3333h
	call fProc

	; call a hand coded version of procedure aProc
	push 4444h
	push 3333h
	call gProc
	call hProc

    exit
main ENDP
; ---------------------
aProc PROC USES eax ebx,
           x: DWORD,
           y: DWORD
        LOCAL a:DWORD, b:DWORD
; this method illustrates how PROTO, INVOKE, PROC, USES, parameters, LOCAL
; generate a stack frame
.data
PARAMS = 2
LOCALS = 2
SAVED_REGS = 2
aProcName BYTE "aProc", 0
.code
  ; assign values to local variables
    mov  a, 0AAAAh
    mov  b, 0BBBBh

  ; display stack frame
    INVOKE WriteStackFrame, PARAMS, LOCALS, SAVED_REGS
    call CrLf

    ret
aProc ENDP

; ---------------------
bProc PROC
; creates a stack frame manually, no parameters, no local variables, no saving
.data
bProcName BYTE "bProc", 0
.code
  ; set up ebp
    push ebp
    mov  ebp, esp
  ; display stack frame
    INVOKE WriteStackFrameName, 0, 0, 0, ADDR bProcName
    mWriteLn "bProc has 0 parameters, 0 local variables and 0 saved registers"
    call CrLf
  ; remove local variables from the stack and restore ebp
    mov  esp, ebp
    pop  ebp
  ; return
    ret
bProc ENDP

; ---------------------
cProc PROC USES eax edx    ; Invalid example
;  This example is invalid.  The stack frame is built incorrectly.  The
;  registers are saved before ebp is pushed on the stack.
.data
cProcName BYTE   "cProc", 0
.code
    push ebp
    mov  ebp, esp
    
    INVOKE WriteStackFrame, 0, 0, 2
    INVOKE WriteStackFrameName, 0, 0, 2, ADDR cProcName
    mWriteLn "** The above stack frame is not a true stack frame        **"
    mWriteLn "** because the procedure has neither parameters nor local **"
    mWriteLn "** variables but has saved registers.  However ebp        **"
    mwriteLn "** was pushed so the output is correct.                   **"
    mWriteLn "cProc has 0 parameters, 0 local variables and 2 saved registers"
    call CrLf
    mov  esp, ebp
    pop  ebp
    ; return
    ret
cProc ENDP

; ---------------------
dProc PROC, x: DWORD
; This procedure has one parameter, but no locals or saved registers.
; Does not print its name.
.code
    INVOKE WriteStackFrame, 1, 0, 0
    mWriteLn "dProc has 1 parameter, 0 local variables and 0 saved registers"
    call CrLf
    ret
dProc ENDP

; ---------------------
eProc PROC
        LOCAL a: DWORD
; This procedure has two local variables but no parameters or saved registers
.data
eProcName BYTE "eProc", 0
.code
    mov  a, 0AAAAh
    INVOKE WriteStackFrameName, 0, 1, 0, ADDR eProcName
    mWriteLn "eProc has 0 parameters, 1 local variable and 0 saved registers"
    call CrLf
    ret
eProc ENDP

; ---------------------
fProc PROC
; this method shows how the stack frame can be generated "by hand"
; it has 2 parameters, 3 local variables and 4 saved registers
.data
fProcName BYTE "fProc", 0
.code
    push ebp
    mov  ebp, esp
  ; reserve space for the local variables
    sub  esp, 12
  ; save other registers
    push eax
    push ebx
    push ecx
    push edx
  ; assign values to local variables
    mov  DWORD PTR [ebp-4], 0AAAAh
    mov  DWORD PTR [ebp-8], 0BBBBh
    mov  DWORD PTR [ebp-12], 0CCCCh
  ; display stack frame
    INVOKE WriteStackFrameName, 2, 3, 4, ADDR fProcName
    mWriteLn "dProc has 2 parameters, 3 local variables and 4 saved registers"
    call CrLf

  ; get ready to return by restoring registers
    pop  edx
    pop  ecx
    pop  ebx
    pop  eax
  ; remove local variables from the stack and restore ebp
    mov  esp, ebp
    pop  ebp
  ; return
    ret  8
fProc ENDP
; ---------------------
gProc PROC
; this method shows how the same stack frame as aProc can be generated "by hand"
; it has 2 parameters, 2 locals
.data
gProcName BYTE "gProc", 0
.code
  ; set up ebp
    push ebp
    mov  ebp, esp
  ; reserve space for the local variables
    sub  esp, 8
  ; save other registers
    push eax
    push ebx
  ; assign values to local variables
    mov  DWORD PTR [ebp-4], 0AAAAh
    mov  DWORD PTR [ebp-8], 0BBBBh
  ; display stack frame
    INVOKE WriteStackFrameName, 2, 2, 2, ADDR gProcName
    mWriteLn "gProc has 2 parameters, 2 local variables and 2 saved registers"
    call CrLf

  ; get ready to return by restoring registers
    pop  ebx
    pop  eax
  ; remove local variables from the stack and restore ebp
    mov  esp, ebp
    pop  ebp
  ; return
    ret  8
gProc ENDP

hProc PROC
.data
hProcName BYTE   "hProc", 0
.code

    INVOKE WriteStackFrame, 0, 0, 2
    INVOKE WriteStackFrameName, 0, 0, 2, ADDR hProcName
    mWriteLn "** The above stack frame is invalid because the procedure **"
    mWriteLn "** has neither parameters nor local variables but has     **"
    mWriteLn "** saved registers.  Moreover the ebp is not pushed on    **"
    mWriteLn "** stack.                                                 **"
    mWriteLn "hProc has 0 parameters, 0 local variables and 2 saved registers"
    call CrLf
    ; return
    ret
hProc ENDP
END main