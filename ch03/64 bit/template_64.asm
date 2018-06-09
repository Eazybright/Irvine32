; 64-bit Assembly Language template 
; Use this when not calling subroutines.

ExitProcess proto

.data
; Declare your variables here.

.code
main proc



	mov   ecx,0			; assign a process return code
	call  ExitProcess	; terminate the program
main endp
end
