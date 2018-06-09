Title 32-bit Division Example             (Divide32.asm)

; This program divides a 64-bit integer dividend
; by a 32-bit divisor. The quotient and remainder
; are each 32 bits.

INCLUDE Irvine32.inc

.data
dividend  QWORD   0000000800300020h
divisor   DWORD   00000100h

.code
main PROC

   mov  edx,dword ptr dividend + 4     ; dividend, high
   mov  eax,dword ptr dividend         ; dividend, low
   div  divisor

; quotient(EAX) = 08003000h, remainder(EDX) = 00000020h

   exit
main ENDP
END main