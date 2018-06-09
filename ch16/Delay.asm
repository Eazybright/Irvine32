TITLE                               (delay.asm)

; Bit 4 of port 61h toggles every 15.085 microseconds
; Must be tested under MS-DOS, Windows 95, or Windows 98.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
milliseconds DWORD 5000

.code
main PROC
	mov  ax,@data
	mov  ds,ax

	mov  eax,0
	mov  cx,5
L1:
	push eax
	mov  eax,milliseconds
	call DelayTest
	pop  eax
	inc  eax
	call WriteDec
	call Crlf
	Loop L1

quit:
	exit
main ENDP

;-----------------------------------------------------------
DelayTest PROC
;
; Create an n-millisecond delay. It has been measured to
; be accurate over a 1-minute time period but it is probably
; not accurate for short durations.
; Receives: EAX = milliseconds
; Returns: nothing
; Comments: The clock frequency should be 15085
;  (15.085 microseconds). The frequency divider is 2.0 microseconds.
;-----------------------------------------------------------

MsToMicro = 1000000	; convert ms to microseconds
ClockFrequency = 2000	; microseconds per tick
.code
	pushad
; Convert milliseconds to microseconds.
	mov  ebx,MsToMicro
	mul  ebx

; Divide by clock frequency of 15.085 microseconds,
; producing the counter for port 61h.
	mov  ebx,ClockFrequency
	div  ebx	; eax = counter
	mov  ecx,eax

; Begin checking port 61h, watching bit 4 toggle
; between 1 and 0 every 15.085 microseconds.
L1:
	in  al,61h	; read port 61h
	and al,10h	; clear all bits except bit 4
	cmp al,ah	; has it changed?
	je  L1	; no: try again
	mov ah,al	; yes: save status
	dec ecx
	cmp ecx,0	; loop finished yet?
	ja  L1

quit:
	popad
	ret
DelayTest ENDP


END main