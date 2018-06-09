; Floating Point IO Procedures           (floatio.asm)

COMMENT @

Authors:  W. A. Barrett, San Jose State University,
          James Brink, Pacific Lutheran University
Used by Permission (July 2005).

Read and Write Float -- these work from keyboard or to screen, using
  Irvine's character fetching and putting functions.

ReadFloat -- accept a float in various formats, returning it in the top
             stack position of the FPU

WriteFloat -- Top stack value in the FPU is written out in a standard
              format.
              
ShowFPUStack -- Displays the floating-point unit's stack.

Updates:
7/18/05: Minor editing and formatting by Kip Irvine
7/19/05  Added checks for infinity and NaN.  
         James Brink, Pacific Lutheran University  (lines marked with *********)
7/20/05  WriteFloat no longer pops the stack. Kip Irvine.
7/22/05  Assembled in 16-bit mode.


THINGS TO FIX:
	
1. If the exponent is over 999, it is shown incorrectly.
2. If a negative exponent is over 3 digits, the procedure halts.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2

INCLUDE irvine16.inc
INCLUDE macros.inc

; set this to 1 to display the FPU stack TOS value:
DOSHOWTOP=0

;--------------------------------------------------------
showTop  MACRO  msg
     local smsg
;
; this macro supports the "showTop msg" scheme
;
;--------------------------------------------------------

IF DOSHOWTOP
     .data
	 smsg byte  0dh, 0ah, msg,0
     .code
     mov   edx,offset smsg
     call  WriteString
     call  showTopF
ENDIF
     ENDM

.data	; variables shared by two or more procedures:

pwr10  DWORD  1,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000
ErrMsg BYTE 0dh,0ah,"Floating point error",0dh,0ah,0

.code

;---------------------------------------------------------
ReadFloat PROC USES eax ebx ecx
   LOCAL expsign:SDWORD, sign:byte
;
; Reads a decimal floating-point number from the keyboard
; and translates to binary floating point. The value is
; placed in SP(0) of the floating-point stack.
;
;----------------------------------------------------------
.data
expint SDWORD  0
itmp       SDWORD  ?
power      REAL8   ?

.code
    showTop  "R begin: "
	  call fpuSet
    mov  sign,0

    ; look for an optional + or - first
    call GetChar
    cmp  al,'+'
    jne  R1
    ; is a '+' -- ignore it; sign= 0
    call GetChar
    jmp  R2
R1:
    cmp  al,'-'
    jne  R2
    ; is a '-' -- sign= 1
    call GetChar
    inc  sign

    ; here we are done with the optional sign flag
R2:
    ; look for a digit in the mantissa part
    .IF (al >= '0' && al <= '9')
      fldz     ; push a 0.  ONE thing in FPU stack
      .WHILE (al >= '0' && al <= '9')
        sub    al,'0'
        and    eax,0Fh
        mov    itmp,eax
        fmul   ten
        fild   itmp
        fadd
        call   GetChar
      .ENDW

      ; decimal point in the mantissa?
      .IF (al == '.')
        call GetChar
        fldz     ; start the fractional part
        fld   ten  ; get the power part started
        fstp  power  ; will be 10, 100, 1000, etc.
        .WHILE (al >= '0' && al <= '9')
          sub  al,'0'
          and  eax,0Fh
          mov  itmp,eax
          fild itmp
          fdiv power
          fadd
          fld  power
          fmul ten
          fstp power
          call GetChar
        .ENDW
        fadd       ; add the front end to the back end
      .ENDIF
    .ELSEIF (al == '.')
      call GetChar
		  ; something like ".ddd"
      fldz	  ; ONE thing in the FPU stack
      fld  ten
      fstp power
      .WHILE (al >= '0' && al <= '9')
        sub  al,'0'
        and  eax,0Fh
        mov  itmp,eax
        fild itmp
        fdiv power
        fadd
        fld  power
        fmul ten
        fstp power
        call GetChar
      .ENDW
    .ELSE
	  ; neither ddd.ddd nor .ddd
	  ; so it's a syntax error
      mov  edx,OFFSET ErrMsg
      call WriteString
	    fldz      ; return a 1.0 in any case
	    call fpuReset
	    showTop "R end: "
      ret
    .ENDIF
      
    ; OK -- now we have the ddd.ddd part in ST(0)
    ; Now look for an exponent
	; We still have the mantissa in the stack:  ONE thing

    .IF (al=='E' || al=='e')
      mov  expsign,1
      call GetChar
      .IF (al=='+')
        call GetChar
      .ELSEIF (al=='-')
        mov  expsign,-1
        call GetChar
      .ENDIF
      mov  expint,0
      .WHILE (al>='0' && al<= '9')
        sub  al,'0'
        and  eax,0FFh
        mov  ebx,eax
        mov  eax,10
        mul  expint
        add  eax,ebx
        mov  expint,eax
		call GetChar
      .ENDW

      ; power10 gets expsign*10^expint, stuffs it in exponent.
      ; Result returned in FPU.
      
      mov  eax,expint
      imul expsign
      call power10    	; TWO things in the FPU stack
      fmul     	; mantissa is sitting underneath; ONE thing left over
    .ENDIF
    .IF (sign==1)
      fchs
    .ENDIF
	  call fpuReset    	; shouldn't affect stack position
	  showTop  "R end: "
	  
    ret    	; result should be in FPU top
ReadFloat  ENDP


;------------------------------------------------------------
ShowFPUStack PROC USES  eax
    LOCAL  temp:REAL8
;
; Prints the FPU stack in decimal exponential format.
; Written by James Brink, Pacific Lutheran University.
; Used by permission.
;
; Adapted by Kip Irvine, 7/18/05.  
; Revised 7/20/05.
;
; Receives:  Nothing
; Returns:  Nothing
;
; Technique:
;     Uses FINCSTP move the stack top, effectly popping 
;     the stack without actually removing values.
; Note:
;     This procedure clears the exception bits in the FPU status register 
;     before it terminates.  This includes B, ES, SF, PE, UE, OE, ZE, DE, 
;     and IE bits.  
; Uses:  
;	  WriteFloat, mWrite, Crlf, WriteDec
;----------------------------------------------------------------
ControlWordMask = 0000000000111111b  ; Used to mask exception bits
.data
SavedCWord WORD ?   ; Control word when the procedure is started
UsedCWord  WORD ?   ; Control word used by procedure

.code
; Write a header message.
	mWrite  <0Dh,0Ah,"------ FPU Stack ------", 0Dh, 0Ah>

; Set the control word to mask the exception bits
        fclex               ; Clear pending exceptions
        fstcw   SavedCWord  ; Get copy of CW used to restore original
        fstcw   UsedCWord
        or      UsedCWord, ControlWordMask
        fldcw   usedCWord   ; Mask exception bits

; Set up counter n for SP(n)
	mov	eax,0
       
; Display the stack (loop)

LDisplay:    
	mWrite  "ST("	; Display stack index
	call    WriteDec
	mWrite  "): "

; Write the value of ST(n) and go to new line.
; WriteFloat pops the value from the stack, so we save
; and restore it to compensate.

; KRI 7/20/05: WriteFloat no longer pops the value from the stack,
; so I commented out the two calls to FST.

	;fst	temp	; save ST(0)
	call	WriteFloat	; write ST(0) & pop
 	;fld	temp	; restore ST(0)
	call	Crlf

; Move the top of stack pointer.
	fincstp             

; Increment count and repeat for 8 values.
	inc	eax 
	cmp	eax,8
	jl	LDisplay

LReturn:
; clear any exceptions and restore original control word before returning
        fclex           ; clear exceptions
        fstcw  SavedCWord
	ret  
ShowFPUStack ENDP


;--------------------------------------------------------------
WriteFloat PROC USES eax ecx edx
;
; Writes the floating point value in the top of the FPU stack 
; to the console window. Displays in exponential format. The 
; value remains on the stack.
;--------------------------------------------------------------
.data
temp_01   REAL8 ?	; KRI
iten    SDWORD  10
mantissa   REAL8 ?
zeroes  BYTE "+0.", 7 DUP('0'), "E+000",0
NaNStr  BYTE "NaN", 0                                     ;******
InfinityStr BYTE "infinity", 0                            ;******
.code
	fst	temp_01	; KRI: save a copy

    showTop  "W begin: "
    call  fpuSet
    ftst                                                  ;******
    call  fChkNaN       ; check for NaN                    ******
    jnz   W0            ; jump if not NaN                  ******
    mov   edx,offset NaNStr  ; print NaN                   ******
    jmp   W0a           ; otherwise this is like a zero    ******
W0:                                                       ;******
    ftst
    call  fcompare   	; look at the sign bit
    jnz   W1
    ; here the thing is all zeroes
    mov   edx,offset zeroes
W0a:
    call  writeString
W0b:
    ;fstp  mantissa
	fst	mantissa	; KRI 7/20/05: changed fstp to fst

    call  fpuReset
	showTop  "W end: "
    ret
W1:
    mov   al,'+'
    jge   W2
    mov   al,'-'
    fchs    	; now have value >= 0
W2:
    call  WriteChar    ; the sign
    call  fChkInfinity ; Check for infinity                ******
    jne   w2a          ; if not continue normally          ******
    mov   al, 0ECh     ; Print "infinity sign"             ******
    call  writeChar                                       ;******
    jmp   W0b          ; finish like for zeros             ******
W2a:    
    ; Suppose the number's value is V.  We first find an exponent E
    ;  and mantissa M such that 10^8 <= M < 10^9 and M*10^-8*10^E = V.
    ; (E will be in 'exponent', M will be in ST(0))
    call splitup
    
    fistp  itmp    	; save as an integer & POP
    
    mov  eax,itmp
    cmp  eax,pwr10+9*4    ; 10^9
    jl   W4
    xor  edx,edx    	; it's > 10^9
    add  eax,5      	; for rounding
    div  iten       	; divide by 10
    inc  exponent
W4:
    ; start with the MSD
    mov  edx,pwr10+8*4
    xor  edx,edx
    div  pwr10+8*4
    and  al,0Fh
    add  al,'0'
    call WriteChar
    mov  al,'.'
    call WriteChar
    mov  eax,edx
    mov  ecx,7
    call wrdigits

    ; that takes care of the decimals after the decimal point
    ; now work on the exponent part
    mov   al,'E'
    call  WriteChar
    .IF (exponent < 0)
      mov  al,'-'
      neg  exponent
    .ELSE
      mov  al,'+'
    .ENDIF
    call  WriteChar

    movzx eax,exponent
    mul   iten
    mov   ecx,3
    call  wrdigits
    
    call  fpuReset
	showTop  "W end: "
	
	fld	temp_01	; KRI: restore saved value
    ret
WriteFloat  endp

;**********************************************************************
;             PRIVATE PROCEDURES
;
;**********************************************************************


;------------------------------------------------------
GetChar  PROC 
;
; Reads a single character from input,
; echoes end of line character to console window.
;
; Modified by Irvine (7/18/05): removed check for Ctl-C.
;------------------------------------------------------

    call ReadChar   	; get a character from keyboard
    .IF (al == 0dh)	; Enter key?
       call Crlf
;    .ELSE
;       call WriteChar  	; and echo it back
    .ENDIF
    ret
GetChar  ENDP


MAXEXPONENT=99

COMMENT #
 fpuSet
  This sets the RC (10,11) & PC (8,9) bits of the FPU control word
  also the exception masks (bits 0..5)
  It saves the current control word
 fpuReset
  Resets FPU to the saved control word

 RC: xx00 0000 0000b
    00 - round to nearest (even)
    01 - round down (toward -inf)
    10 - round up (toward +inf)
    11 - round toward zero (truncate)

 PC: xx 0000 0000b
    00 - single precision (24 bits)
    01 - reserved
    10 - double precision (53 bits)
    11 - double ext. precision (64 bits)

#

; truncate, double precision, all exceptions masked out
stdMask   = 1111000011000000b
stdRMask  = 0000111100111111b
stdControl= 0000111000111111b

.data
stmp word  ?
sw   word  ?
.code

;-------------------------------------------------------
fpuSet PROC uses ax
;
;-------------------------------------------------------
      fstcw sw	; save current control word
      mov   ax,sw
      and   ax,stdMask
      or    ax,stdControl
      mov   stmp,ax
      fldcw stmp	; load masked control word
      ret
fpuSet ENDP

;--------------------------------------------------------
fpuReset  PROC  uses ax bx
;
; This resets the control word
; bits defined by the stdMask
;--------------------------------------------------------
      fstcw stmp	; get current control word
      mov   ax,stmp	; save it in AX
      and   ax,stdMask	; clear bits 6-7, 11-14
      mov   bx,sw	; get saved control word
      and   bx,stdRMask
      or    ax,bx	; set bits 0-5, 8-11
      mov   stmp,ax
      fldcw stmp
	  ret
fpuReset  ENDP


;--------------------------------------------------------
power10  PROC uses ebx ecx
;
; power10 expects:  EAX (signed exponent)
; This returns 10.0^(sign*EAX) in the FPU
;--------------------------------------------------------
.data
binpwr10   REAL8  1.0E64, 1.0E32, 1.0E16, 1.0E8, 1.0E4, 1.0E2, 1.0E1
TOPPWR= ($-binpwr10)/type binpwr10
.code
      .IF (eax == 0)
        fld1   ; load a 1
        ret
      .ENDIF

	   ; get the sign of eax
	   mov  bl,0
	   .IF (sdword ptr eax < 0)
	     neg  eax
	   	 inc  bl
      .ENDIF

      ; check for too-large exponent
      .IF (sdword ptr eax > MAXEXPONENT)
        ; complain
        mov  edx,OFFSET ErrMsg
        call WriteString
        ; ...but return 1.0
        fld1
        ret
      .ENDIF

      ; now for the computation
      ; The general idea is that if eax= 11101b, then the value wanted
      ;  is 10^(11101b)= 10^(2^4) * 10^(2^3) * 10^(2^2) * 10^(2^0)
      ; So we use a table of these powers, binpwr10.
      ; we start with 10^1
      fld1
      mov  ecx,TOPPWR
	  mov  esi,(type binpwr10)*(TOPPWR-1)
    P1:
      test  eax,1
      jz    P2
      fmul  binpwr10[esi]
    P2:
	  sub   esi,type binpwr10
      shr   eax,1
      loopnz  P1
      .IF (bl != 0)
        ; take the reciprocal
        fld1
        fdivr   ; reverse division
      .ENDIF
      ret
power10  ENDP

.data
status  dw 0
showMsg byte "stack top= "
stbyte  byte 0, 0dh, 0ah, 0
.code

IF DOSHOWTOP
;--------------------------------------------------------
showTopF  PROC uses eax edx
;
; showTopF prints the FPU TOP register (0-7) to screen
; This is a diagnostic routine
;--------------------------------------------------------
      fstsw  status
      fwait
      mov    ax,status
      shr    ax,11
      and    al,7   ; TOP is 3 bits
      add    al,'0'
      mov    stbyte,al
      mov    edx,offset showMsg
      call   WriteString
      ret
showTopF  ENDP
ENDIF


;-------------------------------------------------------- ******
fChkNaN PROC  uses ax                                    ;******
;                                                         ******
; Check the results of the last FTST instruction to see   ******
; the Z flag is set if indeed the value was NaN           ******
;        5432109876543210                                 ******
C3C2C0 = 0100010100000000b                               ;******
    fnstsw ax         ; mov the status word to AX         ******
    and   ax, C3C2C0  ; get the C3, C2, C0 bits from the status word
    cmp   ax, C3C2C0  ; are all the bits 0                ******
    ret                                                  ;******
fChkNaN ENDP    				         ;******

;-------------------------------------------------------- ******
fChkInfinity PROC                                        ;******
.data                                                    ;******
temp REAL10 ?                                            ;******
.code                                                    ;******
    fstp  temp ; store value, fst can't store REAL10     ;******
    fld   temp ; restore the stack                       ;******
    mov   ax, WORD PTR temp
    cmp   WORD PTR temp, 0000h; is Exponent all 1 bits    ;******
    jne   CF1                                            ;******
    cmp   DWORD PTR (temp+2), 00000000h                  ;******
    jne   CF1  ; check first 4 bytes of the mantissa     ;******
    cmp   DWORD PTR (temp+6), 7FFF8000h                  ;****** 
           ; this checks last four bytes of the mantissa ;******
CF1:                                                     ;******
    ret                                                  ;******
fChkInfinity ENDP                                        ;******
;--------------------------------------------------------
fcompare PROC uses ax
;
; Compares two floating-point values.
; Transfers ZF & SF registers from the FPU status word
;  to the CPU, so we can do branches on them
;
;--------------------------------------------------------
    fstsw  status
    mov    ah,byte ptr status+1
    mov    al,ah
    and    ah,040h
    and    al,1
    ror    al,1
    or     ah,al
    sahf
    ret
fcompare ENDP

;--------------------------------------------------------
normalize PROC
;
; shifts ST(0) into range 10^8 <= V < 10^9
; and adjusts the exponent in the process
;
;--------------------------------------------------------
.data
tenp8      REAL8  10.0E8
onep8      REAL8  1.0E8
exponent   SWORD   0

.code
N1:
    fcom tenp8   ; compare to 10^9
    call fcompare
    jl   N2
    fdiv ten
    inc  exponent
    jmp  N1

N2:
    fcom onep8   ; compare to 10^8
    call fcompare
    jge  N3
    fmul ten
    dec  exponent
    jmp  N2
N3:
    ret
normalize ENDP

;---------------------------------------------------------
splitup  PROC USES ecx esi edi
;
; Receives a non-negative number in ST(0).
; Suppose the number's value is V.  The goal is to find an exponent E
;  and integer mantissa M such that 10^8 <= M < 10^9 and
;   V= M*10^-8 * 10^E
; (E will be in 'exponent', M will be in ST(0) on return)
; This uses the pwr10 table in an attempt to narrow down the
; appropriate power using a kind of binary search and reduction
;
;---------------------------------------------------------
.data
onehalf    REAL8  0.5
one       REAL8   1.0
ten       REAL8   10.0

bpwr10    WORD  64,32,16,8,4,2,1
binpwrM10 REAL8  1.0E-64, 1.0E-32, 1.0E-16, 1.0E-8, 1.0E-4, 1.0E-2, 1.0E-1

.code
    mov  exponent,0 

    ; see if == 0.0
    ftst
    call fcompare
    jne  S1
    ret

S1:
    ; start by seeing if it's greater than 10
    fcom  ten
    call  fcompare
    jge   S2    ; >= 10
    ; see if it's < 10
    fcom one
    call fcompare
    jge  S4   ; it's >= 10
    jmp  S3   ; it's < 10

S2: ; here, it's > 10
    ; so we'll reduce it using the binpwr10 table
    mov  ecx,TOPPWR
    mov  esi,0    	; index to binpwr10
    mov  edi,0    	; index to bpwr10
S2a:
    fcom binpwr10[esi]
    call fcompare
    jl   S2c
    fdiv binpwr10[esi]
		mov  ax,bpwr10[edi]
    add  exponent,ax
S2c:
    add  esi,type binpwr10
    add  edi,type bpwr10
    loop S2a
    jmp  S4

S3: ; here, it's < 1.0
    mov  ecx,TOPPWR
    mov  esi,0    	; index to binpwrM10
    mov  edi,0    	; index to mpwr10
S3a:
    fcom binpwrM10[esi]
    call fcompare
    jge  S3c
    fdiv binpwrM10[esi]
	mov  ax,bpwr10[edi]
    sub  exponent,ax
S3c:
    add  esi,type binpwr10
    add  edi,type bpwr10
    loop S3a

S4:
    fmul onep8	  ; multiply by 10^8
    ; adjust to range 10^8 <= V < 10^9
    call normalize

; Round the mantissa to 8 decimal places
    fadd onehalf     ; add one half
    frndint          ; should truncate fractional part

    ; readjust to 10^8 <= V < 10^9
    call normalize
    
    ret
splitup  ENDP


;---------------------------------------------------------
wrdigits PROC PRIVATE
;
; (Helper procedure) Writes 'ecx' digits of register eax
;  as decimal digits, with leading zeros.
; 
;---------------------------------------------------------
WR1:
    mov  edx,pwr10[ecx*4]
	xor  edx,edx
    div  pwr10[ecx*4]
    and  al,0Fh
    add  al,'0'
    call WriteChar
    mov  eax,edx
    loop WR1
    
    ret
wrdigits ENDP

    END

