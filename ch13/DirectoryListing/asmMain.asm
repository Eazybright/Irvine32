; ASM program launched from C++    (asmMain.asm)
 
.586
.MODEL flat,C

; Standard C library functions:
system PROTO, pCommand:PTR BYTE
printf PROTO, pString:PTR BYTE, args:VARARG
scanf  PROTO, pFormat:PTR BYTE,pBuffer:PTR BYTE, args:VARARG
fopen  PROTO, mode:PTR BYTE, filename:PTR BYTE
fclose PROTO, pFile:DWORD

BUFFER_SIZE = 5000
.data
str1 BYTE "cls",0
str2 BYTE "dir/w",0
str3 BYTE "Enter the name of a file: ",0
str4 BYTE "%s",0
str5 BYTE "cannot open file",0dh,0ah,0
str6 BYTE "The file has been opened and closed",0dh,0ah,0
modeStr BYTE "r",0

fileName BYTE 60 DUP(0)
pBuf  DWORD ?
pFile DWORD ?

.code
asm_main PROC

    ; clear the screen, display disk directory
    INVOKE system,ADDR str1
    INVOKE system,ADDR str2
    
    ; ask for a filename
    INVOKE printf,ADDR str3
    INVOKE scanf, ADDR str4, ADDR fileName

    ; try to open the file
    INVOKE fopen, ADDR fileName, ADDR modeStr
    mov pFile,eax

    .IF eax == 0                ; cannot open file?
      INVOKE printf,ADDR str5
      jmp quit
    .ELSE
      INVOKE printf,ADDR str6
    .ENDIF

    ; Close the file
    INVOKE fclose, pFile

quit:
    ret             ; return to C++ main
asm_main ENDP

END 
