; Operators (Operator.asm)

; Demonstrates the TYPE, LENGTHOF, and SIZEOF operators

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:dword

.data
byte1    BYTE  10,20,30
array1   WORD  30 DUP(?),0,0
array2   WORD  5 DUP(3 DUP(?))
array3   DWORD 1,2,3,4
digitStr BYTE  '12345678',0
myArray  BYTE  10,20,30,40,50,
               60,70,80,90,100

; You can examine the following constant values
; by looking in the listing file (Operator.lst):
;---------------------------------------------
X = LENGTHOF byte1		; 3
X = LENGTHOF array1		; 30 + 2
X = LENGTHOF array2		; 5 * 3
X = LENGTHOF array3		; 4
X = LENGTHOF digitStr	; 9
X = LENGTHOF myArray	; 10

X = SIZEOF byte1		; 1 * 3
X = SIZEOF array1		; 2 * (30 + 2)
X = SIZEOF array2		; 2 * (5 * 3)
X = SIZEOF array3		; 4 * 4
X = SIZEOF digitStr		; 1 * 9

.code
main PROC






	invoke ExitProcess,0
main ENDP
END main