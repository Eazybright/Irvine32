; cmdtest.asm

INCLUDE Irvine32.inc

.data
    cmdline    BYTE    144 DUP(0)


.code
main PROC
	call  ReadFloat





    ; get command-line arguments
    mov    edx, OFFSET cmdline
    call    GetCommandTail

    ; display command-line string
    call    Crlf
    call    Crlf
    mov    al, '>'
    call    WriteChar
    mov    edx, OFFSET cmdline
    call    WriteString
    mov    al, '<'
    call    WriteChar
    call    Crlf
    call    Crlf
    exit
main ENDP


END main 