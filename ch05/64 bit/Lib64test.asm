; testing 64-bit Windows API			(Lib64test.asm)
;  Chapter 5 example

ExitProcess 	proto
ReadInt64       proto
ReadString      proto
WriteString		proto
WriteInt64		proto
WriteHex32		proto
WriteHex64		proto
Crlf 				proto

.data
message BYTE "Testing the Irvine64 library",0
maxval qword 9223372036854775807
minval qword -9223372036854775808
hexval qword 0123456789ABCDEFh
inbuf  BYTE  50 dup(0),0
inbuf_size = $ - inbuf

.code
main proc

	mov	  rdx,offset message
	call  WriteString
	call  Crlf

	call  ReadInt64				; read value into rax
	call  Crlf
	call  WriteInt64			; display rax 
	call  Crlf

comment !
	mov   rdx,offset inbuf
	mov   rcx,inbuf_size
	call  ReadString			; read a string (RAX = length)
	call  WriteInt64			; display the string length
	call  Crlf
	
	mov   rdx,offset inbuf
	call  WriteString			; display the buffer
	call  Crlf

	mov   rax,minVal
	call  WriteInt64
	call  Crlf

	mov   rax,maxVal
	call  WriteInt64		; display signed value
	call  Crlf

	mov   rax,hexVal
	call  WriteHex32		; display the lower 32 bits
	call  Crlf

	mov   rax,hexVal
	call  WriteHex64		; display all 64 bits
	call  Crlf
!

	mov   ecx,0
	call  ExitProcess
main endp

end