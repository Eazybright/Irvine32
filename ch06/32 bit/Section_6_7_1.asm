; MASM Decision Directives    (Section_6_7_1.asm)

; Examples from Sections 6.7.1 (Creating IF Statements)
; and 6.7.2 (Signed and Unsigned Comparisons)

INCLUDE IRVINE32.inc
INCLUDE macros.inc

.data
val1  DWORD 5
val2  SDWORD -1
result DWORD 0

.code
main PROC

; Example 1
     mov  eax,6
     .IF eax > val1
       mov result,1
     .ENDIF

; Example 2
     
     mov eax,6
     .IF eax > val2
       mov result,1
     .ENDIF

; Example 3

     mov eax,6
     mov ebx,val2
     .IF eax > ebx
       mov result,1
     .ENDIF


	exit
main ENDP

END main